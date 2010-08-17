//
//  FROAuth2Request.m
//
//  Created by Jonathan Dalrymple on 16/08/2010.
//  Copyright 2010 Float:Right. All rights reserved.
//

#import "FROAuth2Request.h"


@implementation FROAuth2Request


//Get Access token
+(FROAuth2Request*) accessTokenForClient:(NSString*) aClient withSecret:(NSString*) aSecret code:(NSString*) aCode redirect:(NSURL*) aURL{
	
	FROAuth2Request	*req;
	
	req = [FROAuth2Request requestWithURL:[NSURL URLWithString:@"https://api.gowalla.com/api/oauth/token"]];
	
	//Set the params
	[req setRequestMethod:@"POST"];
	
	[req setPostValue:@"authorization_code" forKey:@"grant_type"];
	
	[req setPostValue:aClient forKey:@"client_id"];
	
	[req setPostValue:aSecret forKey:@"client_secret"];
	
	[req setPostValue:aCode forKey:@"code"];
	
	[req setPostValue:[aURL absoluteString] forKey:@"redirect_uri"];
	
	return req;
	
}

//Standard request
+(FROAuth2Request*) requestWithURL:(NSURL *)aURL token:(NSString*) aToken{
	
	NSURL	*tokenizedURL;
	
	//Determine if the url as a query
	if( [aURL query] ){
		tokenizedURL = [NSString stringWithFormat:@"%@&oauth_token=%@",[aURL absoluteString],aToken]; 
	}
	else{
		tokenizedURL = [NSString stringWithFormat:@"%@?oauth_token=%@",[aURL absoluteString],aToken];
	}
	
	//NSLog(@"query :%@", tokenizedURL );
	
	return [FROAuth2Request requestWithURL: tokenizedURL];
}

@end
