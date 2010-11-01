//
//  FROAuth2Request.h
//
//  Created by Jonathan Dalrymple on 16/08/2010.
//  Copyright 2010 Float:Right. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FROAuth2Client.h"
#import "FROAuth2Token.h"
#import "ASIFormDataRequest.h"

@interface FROAuth2Request : ASIFormDataRequest {
	FROAuth2Token	*_token;
	FROAuth2Client	*_client;
}

@property (nonatomic,retain) FROAuth2Token *token;
@property (nonatomic,retain) FROAuth2Client *client;

+(FROAuth2Request*) accessTokenForClient:(NSString*) aClient withSecret:(NSString*) aSecret code:(NSString*) aCode redirect:(NSURL*) aURL;

+(FROAuth2Request*) requestWithURL:(NSURL *)newURL token:(FROAuth2Token*) aToken;

+(FROAuth2Request*) accessTokenForClient:(FROAuth2Client*) aClient code:(NSString*) aCode;

//New format
//+(FROAuth2Request*) accessTokenWithClient:(FROAuth2Client) aClient code:(NSString*) aCode;
//+(FROAuth2Request*) requestWithURL:(NSURL *)newURL token:(FROAuth2Token*) aToken;

@end
