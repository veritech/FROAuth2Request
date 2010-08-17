//
//  FROAuthRequestTest.m
//
//  Created by Jonathan Dalrymple on 12/04/2010.
//  Copyright 2010 Float:Right. All rights reserved.
//

#import <GHUnitIOS/GHUnitIOS.h>
#import "FROAuth2Client.h"

@interface FROAuth2ClientTest : GHAsyncTestCase{
	id _subject;
}

@end

@implementation FROAuth2ClientTest

-(void) setUp{
	_subject = [[FROAuth2Client alloc] initWithKey:@"key" secret:@"secret" redirect:[NSURL URLWithString:@"google.com"]];

}

-(void) tearDown{
	[_subject release];
	_subject = nil;
}

-(void) testInstance{
	
	GHAssertNotNil(_subject, @"Not Nil");
	
	GHAssertTrue([_subject isKindOfClass:[FROAuth2Client class]],@"Kind of class");
		
}

-(void) testKey{
	
	GHAssertEqualObjects([_subject key],@"key",@"Key test");
	
}

-(void) testSecret{
	
	GHAssertEqualObjects([_subject secret],@"secret",@"Secret test");
}

-(void) testRedirectURL{
	
	GHAssertEqualObjects([_subject redirectURL],[NSURL URLWithString:@"google.com"],@"Redirect URL");
}

-(void) testAuthorizationURL{
	
	NSURL *url;
	NSString *queryStr;
	
	url = [_subject accessRequestURL: [NSURL URLWithString:@"google.com"]];
	
	queryStr = [NSString stringWithFormat:@"redirect_uri=%@&client_id=%@",[NSURL URLWithString:@"http://float-right.co.uk/oauth"],@"ConsumerKey"];
	
	GHAssertEqualObjects( [url scheme], @"https",@"Is not HTTPS");
	
	GHAssertEqualObjects( [url host],@"gowalla.com",@"Invalid Gowalla url");
	
	GHAssertEqualObjects( [url query], queryStr ,@"Checked the query");
	
	NSLog(@"%@",url);
	
}

@end
