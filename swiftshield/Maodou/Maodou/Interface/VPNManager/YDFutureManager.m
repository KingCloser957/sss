//
//  NSSocks5Manager.m
//  AppProxyProvider
//
//  Created by LinkV on 2022/10/22.
//

#import "YDFutureManager.h"
#include <arpa/inet.h>
#include <dns.h>
#include <resolv.h>
//#import <Future/Future.h>
#import "YDProtocolParser.h"
#import <arpa/inet.h>
#import <mach/mach.h>
#import <resolv.h>
#import <sys/sysctl.h>
#import <sys/time.h>
#import <sys/utsname.h>

#define VPN_USE_TUN2SOCKS 1


//@interface YDFutureManager ()<FuturePlatformWriter, FutureAppleNetworkinterface>
@interface YDFutureManager ()

@property (nonatomic, strong)NSDictionary *xray;
@end

@implementation YDFutureManager {
    
#if ENABLE_APPLE_NETWORK_EXTENSION
    NEPacketTunnelProvider *_mProvider;
#endif
    
    NSMutableArray *_allDnsServer;
    
    NSURLSession *_mSession;
    dispatch_queue_t _mTimerQueue;
    
    long long _mUdpTimeout;
    long long _mTcpTimeout;
    
    long long _mHttpDownFlow;
    long long _mHttpUpFlow;
    long long _mTcpDownFlow;
    long long _mTcpUpFlow;
    
    BOOL _mRunning;
}
+(instancetype)sharedManager {
    static YDFutureManager *__manager__ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager__ = [[self alloc] init];
        [__manager__ setup];
    });
    return __manager__;
}

+ (void)setLogLevel:(xLogLevel)level{
    switch (level) {
        case xLogLevelVerbose:
            [YDProtocolParser setLogLevel:@"verbose"];
            break;
            
        case xLogLevelWarning:
            [YDProtocolParser setLogLevel:@"warning"];
            break;
            
        case xLogLevelInfo:
            [YDProtocolParser setLogLevel:@"info"];
            break;
            
        case xLogLevelError:
            [YDProtocolParser setLogLevel:@"error"];
            break;
    }
}

+ (void)setGlobalProxyEnable:(BOOL)enable {
    [YDProtocolParser setGlobalProxyEnable:enable];
    NSString *file = [[NSBundle mainBundle] pathForResource:@"geosite" ofType:@"dat"];
    if (file && [[NSFileManager defaultManager] fileExistsAtPath:file]) {
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/"];
//        FutureInitV2Env(path);
    }
}

+ (void)setHttpProxyPort:(uint16_t)port {
    [YDProtocolParser setHttpProxyPort:port];
}

+ (void)setDirectDomainList:(NSArray *)list {
    [YDProtocolParser setDirectDomainList:list];
}

+ (void)setProxyDomainList:(NSArray *)list {
    [YDProtocolParser setProxyDomainList:list];
}

+ (void)setBlockDomainList:(NSArray *)list {
    [YDProtocolParser setBlockDomainList:list];
}

+ (NSString *)ping:(NSString *)ips {
//    return FuturePing(ips);
    return @"";
}

- (void)setup {
    _allDnsServer = [NSMutableArray new];
    _mTimerQueue = dispatch_queue_create("sg.linkv.work.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(_mTimerQueue, ^{
        while (true) {
            [self getStats];
            struct timespec timeout;
            timeout.tv_sec = 1;
            timeout.tv_nsec = 0;
            nanosleep(&timeout, NULL);
        }
    });
}

- (BOOL)setupURL:(NSString *)payload {
    NSDictionary *configuration = [YDFutureManager parseURI:payload];
    if (!configuration) return NO;
    self.xray = configuration;
    return YES;
}

+ (NSDictionary *)parseURI:(NSString *)uri {
    NSArray <NSString *>*list = [uri componentsSeparatedByString:@"//"];
    xVPNProtocol protocol;
    if (list.count != 2) {
        return nil;
    }
    if ([list[0] hasPrefix:@"vmess"]) {
        protocol = xVPNProtocolVmess;
    }
    else if ([list[0] hasPrefix:@"vless"]) {
        protocol = xVPNProtocolVless;
    }
    else if ([list[0] hasPrefix:@"ss"]) {
        protocol = xVPNProtocolSs;
    }
    else if ([list[0] hasPrefix:@"ssr"]) {
        protocol = xVPNProtocolSsr;
    }
    else {
        return nil;
    }
    NSDictionary *configuration = [YDProtocolParser parse:list[1] protocol:protocol];
    return configuration;
}
+(NSString *)version {
//    return [NSString stringWithFormat:@"%@-%@",@"25", FutureCheckVersionX()];
    return  @"";
}

+ (NSString *)GetV2Env {
//    return [NSString stringWithFormat:@"%@", FutureGetV2Env()];
    return  @"";
}

#if ENABLE_APPLE_NETWORK_EXTENSION
- (void)setPacketTunnelProvider:(NEPacketTunnelProvider *)provider {
    _mProvider = provider;
}


-(void)WirteToPacketFlow:(NSData *)ipPacket family:(int)family {
    [_mProvider.packetFlow writePackets:@[ipPacket] withProtocols:@[@(family)]];
}

- (NSArray<NSString *> *)allDNSServer {
    return _allDnsServer;
}



-(void)xNSPrint:(NSString *)logStr {
    NSLog(@"lwip=> %@",logStr);
}

- (NEPacketTunnelNetworkSettings *)createNetworkSetting {
    
    [_allDnsServer removeAllObjects];
    
    NEPacketTunnelNetworkSettings *networkSettings = [[NEPacketTunnelNetworkSettings alloc] initWithTunnelRemoteAddress:@"254.1.1.1"];
    NSMutableSet *dns = [NSMutableSet setWithArray:[YDFutureManager sharedManager].DNS];
    
    [_allDnsServer addObjectsFromArray:dns.allObjects];
    networkSettings.DNSSettings = [[NEDNSSettings alloc] initWithServers:_allDnsServer];
    networkSettings.MTU = @(4096);
    
    // 此处其实是创建一个虚拟 IP 地址，需要自行创建路由
    NEIPv4Settings *ipv4Settings = [[NEIPv4Settings alloc] initWithAddresses:@[@"198.18.0.1"] subnetMasks:@[@"255.255.255.0"]];
    ipv4Settings.includedRoutes = @[[NEIPv4Route defaultRoute]];
    ipv4Settings.excludedRoutes = @[];
    networkSettings.IPv4Settings = ipv4Settings;
    
    NEProxySettings *proxySettings = [NEProxySettings new];
    NEProxyServer *http = [[NEProxyServer alloc] initWithAddress:@"127.0.0.1" port:[YDProtocolParser HttpProxyPort]];
    proxySettings.HTTPEnabled = YES;
    proxySettings.HTTPSEnabled = YES;
    proxySettings.HTTPServer = http;
    proxySettings.HTTPSServer = http;
    proxySettings.excludeSimpleHostnames = YES;
    proxySettings.autoProxyConfigurationEnabled = NO;
    proxySettings.exceptionList = @[
        @"captive.apple.com",
        @"10.0.0.0/8",
        @"localhost",
        @"*.local",
        @"172.16.0.0/12",
        @"198.18.0.0/15",
        @"114.114.114.114.dns",
        @"192.168.0.0/16"
    ];
    networkSettings.proxySettings = proxySettings;
    return networkSettings;
}

- (void)writeTo:(NSString* _Nullable)payload {
    NSLog(@"%@",payload);
}

- (long)writePacket:(NSData* _Nullable)payload {
    if (!payload) return 0;
    [_mProvider.packetFlow writePackets:@[payload] withProtocols:@[@(AF_INET)]];
    return payload.length;
}

- (void)startTunnelWithOptions:(NSDictionary *)options completionHandler:(void (^)(NSError *))completionHandler {
    NSString *rayEnv = [YDFutureManager GetV2Env];
    NSLog(@"X-Ray版本 %@", rayEnv);
    if (options[@"uri"]) {
        [self setupURL:options[@"uri"]];
    }
    BOOL global = [options[@"global"] boolValue];
    if (global) {
        [YDFutureManager setGlobalProxyEnable:global];
    }
    if (!self.xray) {
        NSError *error = [NSError errorWithDomain:@"Invalid Configuration" code:-1 userInfo:nil];
        return completionHandler(error);
    }
    __weak YDFutureManager *weakSelf = self;
    NSData *c = [NSJSONSerialization dataWithJSONObject:self.xray options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *r = FutureStartVPN(c, self);
//    if (r.length > 0){
//        NSError *error = [NSError errorWithDomain:@"Invalid json" code:204 userInfo:nil];
//        completionHandler(error);
//        return;
//    }
    
    NSLog(@"vpn configuration: %@", self.xray);
    
#if VPN_USE_TUN2SOCKS
//    FutureRegisterAppleNetworkInterface(self);
#endif
    
    _mRunning = YES;
    NEPacketTunnelNetworkSettings *networkSettings = [self createNetworkSetting];
    [_mProvider setTunnelNetworkSettings:networkSettings completionHandler:^(NSError * _Nullable e) {
        THROW_EXCEPTION(e);
        __strong YDFutureManager *strongSelf = weakSelf;
        [strongSelf readPackets];
        completionHandler(e);
    }];
}

- (void)stopTunnelWithReason:(NEProviderStopReason)reason completionHandler:(void (^)(void))completionHandler {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        FutureStopVPN();
        completionHandler();
    });
}

- (NSArray<NSString *> *)DNS {
    NSMutableArray *dnsList = [NSMutableArray array];
    res_state x = malloc(sizeof(struct __res_state));
    if (res_ninit(x) == 0) {
        for (int i = 0; i < x->nscount; i++) {
            NSString *s = [NSString stringWithUTF8String:inet_ntoa(x->nsaddr_list[i].sin_addr)];
            [dnsList addObject:s];
        }
    }
    res_nclose(x);
    res_ndestroy(x);
    free(x);
    if (dnsList.count == 0) {
        [dnsList addObject:@"114.114.114.114"];
        [dnsList addObject:@"8.8.8.8"];
    }
    return dnsList;
}


- (void)readPackets {
    __weak YDFutureManager *weakSelf = self;
    [_mProvider.packetFlow readPacketsWithCompletionHandler:^(NSArray<NSData *> * _Nonnull packets, NSArray<NSNumber *> * _Nonnull protocols) {
        __strong YDFutureManager *strongSelf = weakSelf;
        for (int i = 0; i < (int)packets.count; i ++) {
#if VPN_USE_TUN2SOCKS
//            FutureWriteAppleNetworkInterfacePacket(packets[i]);
#else
            [strongSelf sendPacket:packets[i] family:protocols[i].intValue];
#endif
        }
        [strongSelf readPackets];
    }];
}

- (void)wake {
    
}

- (void)sleepWithCompletionHandler:(void (^)(void))completionHandler {
    completionHandler();
}

- (void)google204Delay:(nullable VPNDelayResponse)response {
    dispatch_async(dispatch_get_global_queue(0, 0 ), ^{
//        int64_t duration = FutureGoogle204Delay();
//        response(duration != -1, duration);
    });
}

#endif

- (void)getStats {
//    int64_t downlink = FutureQueryStats(@"proxy", @"downlink");
//    int64_t uplink = FutureQueryStats(@"proxy", @"uplink");
//    if ([self.delegate respondsToSelector:@selector(onConnectionSpeedReport:uplink:)]) {
//        [self.delegate onConnectionSpeedReport:downlink uplink:NO];
//        [self.delegate onConnectionSpeedReport:uplink uplink:YES];
//    }
}

#if ENABLE_APPLICATION_VPN
- (void)startTunnelWithOptions:(nullable NSDictionary *)options configuration:(NSDictionary *)configuration {
    NSData *c = [NSJSONSerialization dataWithJSONObject:configuration options:NSJSONWritingPrettyPrinted error:nil];
//    FutureStartVPN(c, self);
}

- (void)stopTunnelWithReason {
//    FutureStopVPN();
}
#endif

#if !ENABLE_APPLE_NETWORK_EXTENSION
- (long)writePacket:(NSData* _Nullable)payload {
    return 0;
}

- (void)writeTo:(NSString* _Nullable)payload {
    
}
#endif


+ (void)setSocks5Enable:(BOOL)socks5Enable {
}

@end
