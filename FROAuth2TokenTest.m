//
//  FROAuth2ClientTest.m
//
//  Created by Jonathan Dalrymple on 16/08/2010.
//  Copyright 2010 Float:Right. All rights reserved.
//

#import <GHUnitIOS/GHUnitIOS.h>
#import "FROAuth2Token.h"

@interface FROAuth2TokenTest : GHTestCase{
	id _subject;
}

@end

@implementation FROAuth2TokenTest

-(void) setUp{
	NSString *sampleResponse;
	
	sampleResponse = @"{\"username\":\"veritech\",\"access_token\":\"ae4c94dc713d7ab3a71e280d74f6aa20\",\"refresh_token\":\"e79b6e4aeb6db9d5048af519d891de4a\",\"scope\":\"read\",\"expires_in\":1208076}";
	
	_subject = [[FROAuth2Token alloc] initWithHTTPResponse:sampleResponse];
	
}

-(void) tearDown{
	[_subject release];
	_subject = nil;
}

-(void) testInstance{
	
	GHAssertNotNil(_subject, @"Not Nil");
	
	GHAssertTrue([_subject isKindOfClass:[FROAuth2Token class]],@"Kind of class");
	
}

-(void) testTokenString{

	GHAssertNotNil([_subject tokenString],@"Token String");
	
	GHAssertTrue([[_subject tokenString] isKindOfClass:[NSString class]],@"Token String type");
	
	GHAssertEqualObjects([_subject tokenString], @"ae4c94dc713d7ab3a71e280d74f6aa20",@"Token String");
	
}

-(void) testTimestamp{
	
	GHAssertNotNil( [_subject expiry],@"Timestamp");
}

-(void) testRefreshToken{
	
	
	GHAssertNotNil( [_subject refreshToken],@"Refresh Token");
	
	GHAssertEqualObjects( [_subject refreshToken],@"e79b6e4aeb6db9d5048af519d891de4a",@"Refresh Token not equal");
	
}

-(void) testIsReadOnly{
	
	GHAssertTrue( [_subject isReadOnly],@"Is token readonly");
}

-(void) testIsValid{
	
	GHAssertTrue( [_subject isValid],@"Token is valid");
	
}

-(void) testSave{
	
	FROAuth2Token	*token;
	
	//Save to disk
	[_subject save];
	
	//Create a new instance
	token = [[FROAuth2Token alloc] init];
	
	[token restore];
	
	GHAssertEqualObjects([token tokenString], @"ae4c94dc713d7ab3a71e280d74f6aa20",@"Token String");
	
	GHAssertEqualObjects( [token refreshToken],@"e79b6e4aeb6db9d5048af519d891de4a",@"Refresh Token not equal");
	
	GHAssertNotNil( [token expiry],@"Timestamp");
	
	GHAssertTrue( [token isReadOnly],@"Is token readonly");
	
	GHAssertTrue( [token isValid],@"Token is valid");
	
	[token release];
	token = nil;
}

@end
