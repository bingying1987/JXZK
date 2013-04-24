//
//  MySocket.h
//  JXZK
//
//  Created by mac on 13-4-22.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CFNetwork/CFNetwork.h>
static const int buflen = 4096; //4kb
@interface MySocket : NSObject
{
    CFSocketRef _tcp_socket;
    Byte m_buf[buflen];
    int _udp_fd;//UDP
    int _count;
}
//tcp
- (BOOL)startConnect:(NSString*)ip port:(NSUInteger)iport;
//udp
- (BOOL)startUdp;
- (void)sendto:(Byte*)buf length:(int)len;
+ (MySocket*)getInstance;
@end


