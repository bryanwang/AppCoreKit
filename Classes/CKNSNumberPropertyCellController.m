//
//  CKNSNumberPropertyCellController.m
//  CloudKit
//
//  Created by Sebastien Morel on 11-04-01.
//  Copyright 2011 WhereCloud Inc. All rights reserved.
//

#import "CKNSNumberPropertyCellController.h"
#import "CKObjectProperty.h"
#import "CKNSObject+bindings.h"
#import "CKLocalization.h"
#import "CKNSNotificationCenter+Edition.h"
#import "CKTableViewCellNextResponder.h"

#define TextEditTag 1
#define SwitchTag 2
#define LabelTag 3

@implementation CKNSNumberPropertyCellController

- (id)init{
	[super init];
	self.cellStyle = CKTableViewCellStyleValue3;
	return self;
}

-(void)dealloc{
	[NSObject removeAllBindingsForContext:[NSValue valueWithNonretainedObject:self]];
	[super dealloc];
}

- (void)onswitch{
	CKObjectProperty* model = self.value;
	UISwitch* s = (UISwitch*)[self.tableViewCell.accessoryView viewWithTag:SwitchTag];
	[model setValue:[NSNumber numberWithBool:s.on]];
	[[NSNotificationCenter defaultCenter]notifyPropertyChange:model];
}

- (void)onvalue{
	CKObjectProperty* model = self.value;
	BOOL bo = [[model value] boolValue];
	
	UISwitch* s = (UISwitch*)[self.tableViewCell.accessoryView viewWithTag:SwitchTag];
	[s setOn:bo animated:YES];
}

- (void)textFieldChanged:(id)value{
	CKObjectProperty* model = self.value;
	[model setValue:value];
	[[NSNotificationCenter defaultCenter]notifyPropertyChange:model];	
}

- (void)initTableViewCell:(UITableViewCell*)cell{
	_accessoryViewSizeRatio = 2.0 / 3.0;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupCell:(UITableViewCell *)cell {
	[super setupCell:cell];
	CKObjectProperty* model = self.value;
	
	CKClassPropertyDescriptor* descriptor = [model descriptor];
	cell.textLabel.text = _(descriptor.name);
	
	switch(descriptor.propertyType){
		case CKClassPropertyDescriptorTypeInt:
		case CKClassPropertyDescriptorTypeShort:
		case CKClassPropertyDescriptorTypeLong:
		case CKClassPropertyDescriptorTypeLongLong:
		case CKClassPropertyDescriptorTypeUnsignedChar:
		case CKClassPropertyDescriptorTypeUnsignedInt:
		case CKClassPropertyDescriptorTypeUnsignedShort:
		case CKClassPropertyDescriptorTypeUnsignedLong:
		case CKClassPropertyDescriptorTypeUnsignedLongLong:
		case CKClassPropertyDescriptorTypeFloat:
		case CKClassPropertyDescriptorTypeDouble:{
			cell.accessoryType = UITableViewCellAccessoryNone;

			UITextField *textField = [[[UITextField alloc] initWithFrame:cell.contentView.bounds] autorelease];
			textField.tag = 50000;
			textField.borderStyle = UITextBorderStyleNone;
			textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			textField.clearButtonMode = UITextFieldViewModeAlways;
			textField.delegate = self;
			textField.keyboardType = UIKeyboardTypeDecimalPad;
			textField.textAlignment = UITextAlignmentLeft;
			textField.autocorrectionType = UITextAutocorrectionTypeNo;
			[cell.contentView addSubview:textField];
	
			break;
		}
		case CKClassPropertyDescriptorTypeChar:
		case CKClassPropertyDescriptorTypeCppBool:{
			UISwitch *toggleSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(0,0,100,100)] autorelease];
			toggleSwitch.tag = SwitchTag;
			cell.accessoryView = toggleSwitch;
			break;
		}
	}	
	
	[self layoutCell:cell];
	
	[NSObject beginBindingsContext:[NSValue valueWithNonretainedObject:self] policy:CKBindingsContextPolicyRemovePreviousBindings];
	UISwitch* s = (UISwitch*)[cell.accessoryView viewWithTag:SwitchTag];
	if(s){
		[model.object bind:model.keyPath target:self action:@selector(onvalue)];
		[s bindEvent:UIControlEventTouchUpInside target:self action:@selector(onswitch)];
	}
	else{
		UITextField *textField = (UITextField*)[cell.contentView viewWithTag:50000];
		[model.object bind:model.keyPath toObject:textField withKeyPath:@"text"];
		[textField bind:@"text" target:self action:@selector(textFieldChanged:)];
		
		NSString* placeholerText = [NSString stringWithFormat:@"%@_Placeholder",descriptor.name];
		textField.placeholder = _(placeholerText);
		
		if([CKTableViewCellNextResponder needsNextKeyboard:self] == YES){
			textField.returnKeyType = UIReturnKeyNext;
		}
		else{
			textField.returnKeyType = UIReturnKeyDone;
		}
	}
	[NSObject endBindingsContext];
}

- (void)layoutCell:(UITableViewCell *)cell{
	[super layoutCell:cell];
	UISwitch* s = (UISwitch*)[cell.accessoryView viewWithTag:SwitchTag];
	if(s == nil){
		UITextField *textField = (UITextField*)[cell.contentView viewWithTag:50000];
		//FIXME : here we could manage layout to fit with value1, value2, subTitle && value3 ...
		//if(self.cellStyle == CKTableViewCellStyleValue3){
			textField.frame = [self value3FrameForCell:cell];
			textField.autoresizingMask = UIViewAutoresizingNone;
		//}
	}
}

+ (NSValue*)viewSizeForObject:(id)object withParams:(NSDictionary*)params{
	return [NSValue valueWithCGSize:CGSizeMake(100,44)];
}

- (void)rotateCell:(UITableViewCell*)cell withParams:(NSDictionary*)params animated:(BOOL)animated{
	[super rotateCell:cell withParams:params animated:animated];
}

+ (CKItemViewFlags)flagsForObject:(id)object withParams:(NSDictionary*)params{
	return CKItemViewFlagNone;
}

#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if([CKTableViewCellNextResponder activateNextResponderFromController:self] == NO){
		[textField resignFirstResponder];
	}
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	//TODO : filter numbers
	return YES;
}

#pragma mark Keyboard

- (void)keyboardDidShow:(NSNotification *)notification {
	[[self parentTableView] scrollToRowAtIndexPath:self.indexPath 
										   atScrollPosition:UITableViewScrollPositionNone 
												   animated:YES];
}

+ (BOOL)hasAccessoryResponderWithValue:(id)object{
	CKObjectProperty* model = object;
	
	CKClassPropertyDescriptor* descriptor = [model descriptor];
	switch(descriptor.propertyType){
		case CKClassPropertyDescriptorTypeChar:
		case CKClassPropertyDescriptorTypeCppBool:
			return NO;
	}
	return YES;
}

+ (UIResponder*)responderInView:(UIView*)view{
	UITextField *textField = (UITextField*)[view viewWithTag:50000];
	return textField;
}

@end