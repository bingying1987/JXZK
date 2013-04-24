//
//  MySocket.m
//  JXZK
//
//  Created by mac on 13-4-22.
//  Copyright (c) 2013年 mac. All rights reserved.
//

#import "MySocket.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <fcntl.h>
@implementation MySocket

MySocket* globalSocket = nil;

+ (MySocket*)getInstance
{
    if (globalSocket == nil) {
        globalSocket = [[MySocket alloc] init];
        
    }
    return globalSocket;
}


const Byte CRC_TABLE[256]={
    0, 94, 188, 226, 97, 63, 221, 131, 194, 156, 126, 32, 163, 253, 31, 65
    ,157, 195, 33, 127, 252, 162, 64, 30, 95, 1, 227, 189, 62, 96, 130, 220
    ,35, 125, 159, 193, 66, 28, 254, 160, 225, 191, 93, 3, 128, 222, 60, 98
    ,190, 224, 2, 92, 223, 129, 99, 61, 124, 34, 192, 158, 29, 67, 161, 255
    ,70, 24, 250, 164, 39, 121, 155, 197, 132, 218, 56, 102, 229, 187, 89, 7
    ,219, 133, 103, 57, 186, 228, 6, 88, 25, 71, 165, 251, 120, 38, 196, 154
    ,101, 59, 217, 135, 4, 90, 184, 230, 167, 249, 27, 69, 198, 152, 122, 36
    ,248, 166, 68, 26, 153, 199, 37, 123, 58, 100, 134, 216, 91, 5, 231, 185
    ,140, 210, 48, 110, 237, 179, 81, 15, 78, 16, 242, 172, 47, 113, 147, 205
    ,17, 79, 173, 243, 112, 46, 204, 146, 211, 141, 111, 49, 178, 236, 14, 80
    ,175, 241, 19, 77, 206, 144, 114, 44, 109, 51, 209, 143, 12, 82, 176, 238
    ,50, 108, 142, 208, 83, 13, 239, 177, 240, 174, 76, 18, 145, 207, 45, 115
    ,202, 148, 118, 40, 171, 245, 23, 73, 8, 86, 180, 234, 105, 55, 213, 139
    ,87, 9, 235, 181, 54, 104, 138, 212, 149, 203, 41, 119, 244, 170, 72, 22
    ,233, 183, 85, 11, 136, 214, 52, 106, 43, 117, 151, 201, 74, 20, 246, 168
    ,116, 42, 200, 150, 21, 75, 169, 247, 182, 232, 10, 84, 215, 137, 107, 53
};



- (Byte)GetStrCRC8:(Byte*)str length:(uint)len
{
    Byte crcCode = 0;
    for (uint i = 0; i < len; i++) {
        crcCode = CRC_TABLE[str[i] ^ crcCode];
    }
    return crcCode;
}

- (void)sendto:(Byte*)buf length:(int)len
{
    if (_udp_fd == 0) {
        if (![self startUdp]) {
            NSLog(@"start udp client error!");
            return;
        }
    }
    if (len < 11) {
        NSLog(@"buf to sendto is too short");
        return;
    }
    buf[8] = _count++;
    buf[9] = [self GetStrCRC8:&buf[2] length:7];
    
    struct sockaddr_in serv_addr;
    bzero(&serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(1024);
    serv_addr.sin_addr.s_addr = inet_addr([@"192.168.1.101" UTF8String]);
    
    
    int ret1 = sendto(_udp_fd, buf, len, 0, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
    if (ret1 == -1 && errno != EAGAIN) {
        NSLog(@"sendto failed!");
        close(_udp_fd);
        _udp_fd = 0;
    }
}

static void ClientReadCallBack(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    /*
    MediaViewController *obj;
    obj = (__bridge MediaViewController*)info;
    assert([obj isKindOfClass:[MediaViewController class]]);
#pragma unused(s)
    assert(s == obj->_socket);
#pragma unused(type)
    assert(type == kCFSocketReadCallBack);
#pragma unused(address)
    assert(address == nil);
#pragma unused(data)
    assert(data == nil);
    
    [obj _readData];
     */
    
}

- (void)Send_GetMediaInfo
{
    /*
    Byte buf[3] = {CMD_SEND_GETMEDIAINFO,0x0,0x1};
    ssize_t bufsended = 0;
    bufsended = send(CFSocketGetNative(_socket), buf, 3, 0);
    if (bufsended == -1) {
        NSLog(@"发送获取列表请求失败.错误码:%d",errno);
        if (errno != EAGAIN) {
            [self StartConnect];
        }else
        {
            NSLog(@"Tcp EAGIN");
        }
    }
     */
}


- (BOOL)startConnect:(NSString*)ip port:(NSUInteger)iport
{
    if (_tcp_socket != NULL) {
        close(CFSocketGetNative(_tcp_socket));
    }
    CFSocketContext ctx = {0,0,/*(__bridge void *)(self),*/NULL,NULL,NULL};
    CFRunLoopSourceRef rls;
    _tcp_socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketReadCallBack, ClientReadCallBack, &ctx);
/*
    int val;
    val = fcntl(CFSocketGetNative(_tcp_socket),F_GETFL,0);
    val = fcntl(CFSocketGetNative(_tcp_socket),F_SETFL, val|O_NONBLOCK);
    if (val == -1) {
        NSLog(@"设置TCP为非阻塞模式失败");
    }
*/ //其实 这个CFSocket应该就时非阻塞的
    assert(_tcp_socket != NULL);
    assert(CFSocketGetSocketFlags(self->_tcp_socket) & kCFSocketCloseOnInvalidate);
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_len = sizeof(addr);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(iport);
    addr.sin_addr.s_addr = inet_addr([ip UTF8String]);
    
    CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8*)&addr, sizeof(addr));
    
    CFSocketError err = CFSocketConnectToAddress(_tcp_socket, address, 2);
    if (err != 0) {
        close(CFSocketGetNative(_tcp_socket));
        return FALSE;
    }
    CFRunLoopRef cfrl = CFRunLoopGetCurrent();
    rls = CFSocketCreateRunLoopSource(NULL, _tcp_socket, 0);
    assert(rls != NULL);
    CFRunLoopAddSource(cfrl, rls, kCFRunLoopCommonModes);
    CFRelease(rls);
    return TRUE;
}

- (BOOL)startUdp
{
    _udp_fd = -1;
    if ((_udp_fd = socket(AF_INET,SOCK_DGRAM, IPPROTO_IP)) == -1) {
        NSLog(@"创建UDP失败:%d",errno);
        return FALSE;
    }
    int val;
    val = fcntl(_udp_fd,F_GETFL,0);
    val = fcntl(_udp_fd,F_SETFL, val|O_NONBLOCK);
    if (val == -1) {
        NSLog(@"设置UDP为非阻塞模式失败");
        return FALSE;
    }

    return TRUE;
}

@end
