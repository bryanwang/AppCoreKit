//
//  CKLayout.m
//  CloudKit
//
//  Created by Fred Brunel on 10-02-22.
//  Copyright 2010 WhereCloud Inc. All rights reserved.
//

#import "CKLayout.h"

// See NSTextBlock
// Block padding, margin

@interface CKLayoutBlock ()

@property (retain, readwrite) NSString *name;

@end

@implementation CKLayoutBlock

@synthesize name = _name;
@synthesize rect = _rect;

- (id)initWithRect:(CGRect)rect {
	if (self = [super init]) {
		_rect = CGRectIntegral(rect);
	}
	return self;
}

- (void)dealloc {
	[_name release];
	[super dealloc];
}

+ (id)blockWithRect:(CGRect)rect {
	return [[[CKLayoutBlock alloc] initWithRect:rect] autorelease];
}

+ (id)blockWithSize:(CGSize)size name:(NSString *)name {
	CKLayoutBlock *block = [CKLayoutBlock blockWithRect:CGRectMake(0, 0, size.width, size.height)];
	block.name = name;
	return block;
}

//

- (NSString *)description {
	return [NSString stringWithFormat:@"<CKLayoutBlock [%@]%@>", NSStringFromCGRect(_rect), 
			self.name ? [NSString stringWithFormat:@" %@", self.name] : @""];
}

@end

//

@implementation CKLayout

+ (id)layout {
	return [[[CKLayout alloc] init] autorelease];
}

//

- (NSArray *)layoutLineOfBlocks:(NSArray *)blocks 
					  lineIndex:(NSUInteger)lineIndex 
					  lineWidth:(CGFloat)lineWidth 
					 lineHeight:(CGFloat)lineHeight 
					  justified:(BOOL)justified {

	// Compute the total length of the current blocks in order to calculate
	// the length ratio.
	
	CGFloat length = 0;
	for (CKLayoutBlock *block in blocks) { 
		length += block.rect.size.width; 
	}
	
	// Create new aligned blocks; expanding width so that they will fit the
	// line (the width of each block respect the aspect ratio from their
	// original size).
	
	NSMutableArray *theBlocks = [NSMutableArray array];
	
	CGFloat offset = 0;
	for (CKLayoutBlock *block in blocks) {
		CGFloat theWidth = justified ? ((block.rect.size.width / length) * lineWidth) : block.rect.size.width;
		CKLayoutBlock *theBlock = [CKLayoutBlock blockWithRect:CGRectMake(offset, lineIndex * lineHeight, theWidth, lineHeight)];
		theBlock.name = block.name;
		[theBlocks addObject:theBlock];
		offset += theBlock.rect.size.width;
	}
	
	return theBlocks;
}

- (NSArray *)layoutBlocks:(NSArray *)blocks alignement:(CKLayoutAlignment)alignement lineWidth:(CGFloat)lineWidth lineHeight:(CGFloat)lineHeight {
	
	// #1 break blocks in lines
	
	NSEnumerator *e = [blocks objectEnumerator];
	NSMutableArray *linesOfBlocks = [NSMutableArray array];
	NSMutableArray *currentLineOfBlocks = [NSMutableArray array];
	CGFloat lineWidthLeft = lineWidth;
	
	for (CKLayoutBlock *block = [e nextObject]; block; ) {
		if (block.rect.size.width <= lineWidthLeft) {
			[currentLineOfBlocks addObject:block];
			lineWidthLeft -= block.rect.size.width;
			block = [e nextObject];
			continue;
		}
		
		[linesOfBlocks addObject:currentLineOfBlocks];		
		currentLineOfBlocks = [NSMutableArray array];
		lineWidthLeft = lineWidth;
			
		// Handle the case of a block.width > line-width, insert it in as 
		// a block on a single line.
		
		if (block.rect.size.width > lineWidth) {
			[linesOfBlocks addObject:[NSArray arrayWithObject:block]];
			block = [e nextObject];
		}		
	}
	
	if (currentLineOfBlocks.count != 0) {
		[linesOfBlocks addObject:currentLineOfBlocks];	
	}
	
	// #2 justify blocks for each line; aggregate the results in a new array
	// of blocks
	
	NSMutableArray *theBlocks = [NSMutableArray array];
	
	for (NSUInteger i = 0; i < linesOfBlocks.count; i++) {
		[theBlocks addObjectsFromArray:[self layoutLineOfBlocks:[linesOfBlocks objectAtIndex:i] 
													  lineIndex:i 
													  lineWidth:lineWidth 
													 lineHeight:lineHeight
													  justified:YES]];
	}
	
	return theBlocks;
}

@end