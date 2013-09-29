//
//  SHXStatusView.m
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXStatusView.h"
#import "SHXPopoverViewController.h"

#define ImageViewWidth 26

@interface SHXStatusView()
{
    BOOL _active;
    
    NSImageView *_imageView;
    NSImageView *_shadowImageView;
    NSStatusItem *_statusItem;
    NSPopover *_popover;
    
}

@end

@implementation SHXStatusView


- (id)init
{
    CGFloat height = [NSStatusBar systemStatusBar].thickness;
    self = [super initWithFrame:NSMakeRect(0, 0, ImageViewWidth, height)];
    if (self) {
        _imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, ImageViewWidth, height)];
        _shadowImageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, ImageViewWidth, height)];
        _shadowImageView.image = [NSImage imageNamed:@"statusbar-white"];
        [self addSubview:_imageView];
        [self addSubview:_shadowImageView];
        
        _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:(ImageViewWidth)];
        _statusItem.view = self;
        
        _popover = [[NSPopover alloc] init];
        _popover.contentViewController = [[SHXPopoverViewController alloc] initWithNibName:@"PopoverView" bundle:nil];
        
        [self updateUI];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (_active) {
        [[NSColor selectedMenuItemColor] setFill];
        NSRectFill(dirtyRect);
    } else {
        [[NSColor clearColor] setFill];
        NSRectFill(dirtyRect);
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    if(_active)
    {
        [self hidePopover];
        [self setActive:NO];
    }
    else
    {
        [self showPopover];
        [self setActive:YES];
    }
}

- (void)updateUI
{
    _imageView.image = [NSImage imageNamed:_active ? @"statusbar-white" : @"statusbar-black"];
    [_shadowImageView setHidden:!_active];
    [self setNeedsDisplay:YES];
}

- (void)setActive:(BOOL)active
{
    _active = active;
    [self updateUI];
}

- (void)showPopover
{
    if (!_popover.isShown) {
        [_popover showRelativeToRect:self.frame
                              ofView:self
                       preferredEdge:NSMinYEdge];
    }
}

- (void)hidePopover
{
    if (_popover != nil && _popover.isShown) {
        [_popover close];
    }
}


@end
