//
//  QDisplayApp.h
//  QDisplay
//
//  Created by Christopher Ashworth on 2/10/11.
//
//  Copyright (c) 2011 Figure 53 LLC, http://figure53.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Cocoa/Cocoa.h>


#import "BBOSCArgument.h"
#import "BBOSCListener.h"
#import "BBOSCDispatcher.h"
#import "BBOSCDataUtilities.h"
#import "BBOSCMessage.h"
#import "BBOSCBundle.h"
#import "BBOSCDecoder.h"
#import "BBOSCSender.h"
#import "BBOSCAddress.h"

@interface QDisplayApp : NSApplication <NSApplicationDelegate>
{
	NSString *message;
    NSWindow *window;
	IBOutlet NSTextField *label;
    IBOutlet NSTextField *countdownLabel;
    NSTimer *countdownTimer;
    double countdownTargetTimeInterval;
	
	BBOSCSender * oscSender;
}

@property (copy) NSString *message;
@property (copy) NSNumber *timeRemaining;
@property (retain) IBOutlet NSWindow *window;
@property (retain) BBOSCSender* oscSender;

@end
