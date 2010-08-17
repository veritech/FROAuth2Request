//
//  FROAuthRequestTest.m
//
//  Created by Jonathan Dalrymple on 12/04/2010.
//  Copyright 2010 Float:Right. All rights reserved.
//

#import <GHUnitIOS/GHUnitIOS.h>
#import "FROAuth2Request.h"

@interface FROAuth2RequestTest : GHAsyncTestCase{
	id _subject;
}

@end

@implementation FROAuth2RequestTest

-(void) setUp{
	_subject = [[FROAuth2Request alloc] init];
		
	[_subject setDelegate: self];

}

-(void) tearDown{
	[_subject release];
	_subject = nil;
}

-(void) testInstance{
	
	GHAssertNotNil(_subject, @"Not Nil");
	
	GHAssertTrue([_subject isKindOfClass:[FROAuth2Request class]],@"Kind of class");
		
}



-(void) testGetAccessToken{
	
	FROAuth2Request *request;
	
	request = [FROAuth2Request accessTokenForClient: @"ConsumerKey"
										 withSecret: @"ConsumerSecret"
											   code: @"12f3af30dbbffb141cc176e91ae9d087"
										   redirect: [NSURL URLWithString:@"http://float-right.co.uk/oauth"]
			   ];
	
	[request setDelegate:self];
	
	[request startSynchronous];

	//NSLog(@"response string %@",[request responseString]);
}
//Callbacks
-(void) requestDidFinish:(id) aRequest{
	
	//[self notify:kGHUnitWaitStatusSuccess];
	NSLog(@"response string %@",[aRequest responseString]);
	
	GHAssertTrue(NO,@"Request Finished");
}

-(void) requestDidFail:(id) aRequest{
	
	GHAssertTrue(NO,@"Request failted");
}


-(void) testRequest{
	
	FROAuth2Request *request;
	
	request = [FROAuth2Request requestWithURL:[NSURL URLWithString:@"https://api.gowalla.com/users/veritech"] 
										token:@"ae4c94dc713d7ab3a71e280d74f6aa20"
			   ];
	
	[request setDelegate:self];
	
	//[request startSynchronous];
	
}

@end
