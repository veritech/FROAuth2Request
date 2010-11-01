//
//  FROAuth2Request.m
//
//  Created by Jonathan Dalrymple on 16/08/2010.
//  Copyright 2010 Float:Right. All rights reserved.
//

#import "FROAuth2Request.h"


@implementation FROAuth2Request

@synthesize token = _token;
@synthesize client = _client;

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//					Class methods
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//Generate a access token request
+(FROAuth2Request*) accessTokenForClient:(FROAuth2Client*) aClient code:(NSString*) aCode{
	
	ASIFormDataRequest	*req;
	
	req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://api.gowalla.com/api/oauth/token"]];
	
	//Set the params
	[req setRequestMethod:@"POST"];
	
	[req setPostValue:@"authorization_code" forKey:@"grant_type"];
	
	[req setPostValue:[aClient key] forKey:@"client_id"];
	
	[req setPostValue:[aClient secret] forKey:@"client_secret"];
	
	[req setPostValue:@"read-write" forKey:@"scope"];
		
	[req setPostValue:[[aClient redirectURL] absoluteString] forKey:@"redirect_uri"];
	
	[req setPostValue:aCode forKey:@"code"];
	
	return req;
	
}

//Generate a refresh token request
+(FROAuth2Request*) refreshToken:(FROAuth2Token*) aToken forClient:(FROAuth2Client*) aClient{

	ASIFormDataRequest *req;
	
	req = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"https://api.gowalla.com/api/oauth/token"]];
	
	[req setPostValue:@"refresh_token" forKey:@"grant_type"];
	
	[req setPostValue:[aClient key] forKey:@"client_id"];
	
	[req setPostValue:[aClient secret] forKey:@"client_secret"];
	
	[req setPostValue:[aToken refreshToken] forKey:@"refresh_token"];
	
	return req;
}


//Standard request
+(FROAuth2Request*) requestWithURL:(NSURL *)aURL token:(FROAuth2Token*) aToken{
	
	FROAuth2Request		*req;
	//Determine if the url as a query
	if( ![[aURL scheme] isEqualToString:@"https"] ){
		[NSException raise:@"Non HTTPS request" format:@"Request to %@ is not HTTP",aURL];
	}
	
	if( ![aToken isValid] ){
		//[NSException raise:@"Invalid Token" format:@"Invalid Token %@ ",aToken];
	}
	
	req =  [FROAuth2Request requestWithURL: aURL];
	
	[req setToken:aToken];
	
	return req;
}

//Request with auto renewing tokens
+(FROAuth2Request*) requestWithURL:(NSURL *)aURL token:(FROAuth2Token*) aToken forClient:(FROAuth2Client*) aClient{

	FROAuth2Request	*req;
	
	req = [FROAuth2Request requestWithURL:aURL token:aToken];
	
	[req setClient:aClient];
	
	return req;
}
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//					Instance methods
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
- (void)buildPostBody{

	//Set the token
	if( [[self requestMethod] isEqualToString:@"POST"] ){
		[self setPostValue:[[self token] tokenString]  forKey:@"oauth_token"];
	}
	else{
		[self addRequestHeader:@"Authorize" value:[NSString stringWithFormat:@"Token token=%@",[[self token] tokenString]]];
	}
	
	DebugLog(@"Params %@", [self postData]);
	[super buildPostBody];
	
}

//Override
-(void) startAsynchronous{
	
	//Has the token expired?
	if( ![[self token] isValid] ){
	
		ASIFormDataRequest	*refreshRequest;
		
		refreshRequest = [FROAuth2Request refreshToken:[self token] forClient:[self client]];
		
		[refreshRequest setDelegate:self];
		[refreshRequest setDidFinishSelector:@selector(refreshTokenRequestDidFinish:)];
		[refreshRequest setDidFailSelector:@selector(refreshTokenRequestDidFail:)];
		
		[refreshRequest setUserInfo:[NSDictionary dictionaryWithObject:self forKey:@"ParentRequest"]];
		[refreshRequest startAsynchronous];
	}
	else {
		[self _startAsynchronous];
	}

}

//Private startAsynchronous method that skips the above
-(void) _startAsynchronous{
	[super startAsynchronous];
}

//token refresh callbacks
-(void) refreshTokenRequestDidFinish:(ASIHTTPRequest*) aRequest{
	DebugLog(@"%@",[aRequest responseString]);
	
	FROAuth2Token	*newToken;
	FROAuth2Request	*parentRequest;
	
	//Create the token
	newToken = [[FROAuth2Token alloc] initWithHTTPResponse:[aRequest responseString]];
	
	if( newToken && (parentRequest = [[aRequest userInfo] objectForKey:@"ParentRequest"]) ){
		
		//Save the token
		[newToken save];
		
		[parentRequest setToken:newToken];
		//Call this private method to avoid a inifinate loop
		[parentRequest _startAsynchronous];
	}
}

-(void) refreshTokenRequestDidFail:(ASIHTTPRequest *)aRequest{
	DebugLog(@"%@",[aRequest error]);
}

-(void) dealloc{
	
	[_token release];
	_token = nil;
	
	[super dealloc];
}

@end
