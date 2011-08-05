//
//  QDisplayApp.m
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
//
//
//
//
//	OSC SUPPORT ADDED BY sorenknud.dk with help from halfdanj.dk
//	




#import "QDisplayApp.h"


@interface QDisplayApp (Private)

- (void) updateCountdownLabel:(NSTimer *)t;

@end


@implementation QDisplayApp
@synthesize oscSender;

- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[window center];
	[window makeKeyAndOrderFront:self];
	message = [[label stringValue] copy];
    countdownTargetTimeInterval = 0.0;
    countdownTimer = nil;
	
	[self createSender];

}


@synthesize window;

- (void) setMessage:(NSString *)newMessage
{
	[message autorelease];
	message = [newMessage copy];
	
	if ( message )
		[label setStringValue:message];
	else
		[label setStringValue:@""];
	
	
	BBOSCMessage * newOscMessage = [BBOSCMessage messageWithBBOSCAddress:[BBOSCAddress addressWithString:@"/ard/cue"]];
	[newOscMessage attachArgument:[BBOSCArgument argumentWithString:message]];
	if (![[self oscSender] sendOSCPacket:newOscMessage]) {
		NSLog(@"Oh Noes!!");
	}	
}

@synthesize message;

- (void) setTimeRemaining:(NSNumber *)newTime
{
    double newSeconds = [newTime doubleValue];
    if (newSeconds <= 0.0) return;
    countdownTargetTimeInterval = [NSDate timeIntervalSinceReferenceDate] + newSeconds;
    [countdownTimer invalidate];
    countdownTimer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(updateCountdownLabel:) userInfo:nil repeats:YES];
}

- (NSNumber *) timeRemaining
{
    return [NSNumber numberWithDouble:countdownTargetTimeInterval - [NSDate timeIntervalSinceReferenceDate]];
}


-(IBAction) setIpAdress:(id)sender{
	[self createSender];

}

-(IBAction) setPort:(id)sender{
	[self createSender];
}

-(void) createSender{
	[self setOscSender:[BBOSCSender senderWithDestinationHostName:[ipAdressField stringValue] portNumber:[portField intValue]]];
	NSLog(@"Create osc sender: ip: %@ port %i",[ipAdressField stringValue], [portField intValue]);
}


@end


@implementation QDisplayApp (Private)

- (void) updateCountdownLabel:(NSTimer *)t
{
    double seconds = countdownTargetTimeInterval - [NSDate timeIntervalSinceReferenceDate];
    if (seconds < 0)
    {
        [countdownTimer invalidate];
        countdownTimer = nil;
        [countdownLabel setStringValue:@"00:00:00:00"];
		BBOSCMessage * newOscMessage2 = [BBOSCMessage messageWithBBOSCAddress:[BBOSCAddress addressWithString:@"/ard/timeleft"]];
		[newOscMessage2 attachArgument:[BBOSCArgument argumentWithFloat:0.0]];
		if (![[self oscSender] sendOSCPacket:newOscMessage2]) {
			NSLog(@"Oh Noes!!3");
		}	
		
    }
    else
    {
        float floatSeconds = (float) (countdownTargetTimeInterval - [NSDate timeIntervalSinceReferenceDate]);
		int intSeconds = (int) (countdownTargetTimeInterval - [NSDate timeIntervalSinceReferenceDate]);
		float millis = (float) ((floatSeconds-intSeconds));
		int frames = (float) (millis*25);
		int hours = (float) (seconds / 3600.0);
        seconds = fmod(seconds, 3600.0);
        int minutes = (float)(seconds / 60.0);
        seconds = fmod(seconds, 60.0);
		int labelSeconds = (float) (seconds);
		
		[countdownLabel setStringValue:[NSString stringWithFormat:@"%02.2d:%02.2d:%02.2d:%02.2d",
										hours,
										minutes,
										labelSeconds,
										frames
										]];
											

			BBOSCMessage * newOscMessage2 = [BBOSCMessage messageWithBBOSCAddress:[BBOSCAddress addressWithString:@"/ard/timeleft"]];
		[newOscMessage2 attachArgument:[BBOSCArgument argumentWithFloat:floatSeconds]];
		if (![[self oscSender] sendOSCPacket:newOscMessage2]) {
			NSLog(@"Oh Noes!!2");
		}	
	}
	
	
}
	
@end
