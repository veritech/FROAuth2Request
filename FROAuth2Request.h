//
//  FROAuth2Request.h
//
//  Created by Jonathan Dalrymple on 16/08/2010.
//  Copyright 2010 Float:Right. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FROAuth2Client.h"
#import "ASIFormDataRequest.h"

@interface FROAuth2Request : ASIFormDataRequest {

}

+(FROAuth2Request*) accessTokenForClient:(NSString*) aClient withSecret:(NSString*) aSecret code:(NSString*) aCode redirect:(NSURL*) aURL;

+(FROAuth2Request*) requestWithURL:(NSURL *)newURL token:(NSString*) aToken;

//New format
//+(FROAuth2Request*) accessTokenWithClient:(FROAuth2Client) aClient code:(NSString*) aCode;
//+(FROAuth2Request*) requestWithURL:(NSURL *)newURL token:(FROAuth2Token*) aToken;

@end
