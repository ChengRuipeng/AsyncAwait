//
//  Tests.m
//  RJIterator
//
//  Created by renjinkui on 2018/4/13.
//  Copyright © 2018年 JK. All rights reserved.
//

#import "Tests.h"
#import <UIKit/UIKit.h>
#import "RJIterator.h"



static NSString* talk(NSString *name) {
    rj_yield([NSString stringWithFormat:@"Hello %@, How are you?", name]);
    rj_yield(@"Today is Friday");
    rj_yield(@"So yestday is Thursday");
    rj_yield(@"And tomorrow is Saturday");
    rj_yield(@"Over");
    return @"==talk done==";
}


@implementation Tests

+ (void)verboseTest {
    [self testArc1];
//    [self test1];
//    [self test2];
//    [self test3];
//    [self test4];
//    [self test5];
//    [self test6];
//    [self test7];
//    [self test8];
//    [self testAsync1];
//    [self testAsync2];
}

+ (id)getObj {
    return [Tests new];
}

+ (void)testArc1 {
    Tests *alloced = [self getObj];
    Tests *__strong stronged = alloced;
    Tests *__weak weaked = alloced;
}

+ (void)test1 {
    NSLog(@"************************ Begin %s *******************************", __func__);
    RJIterator *it = nil;
    RJResult *r = nil;
    
    it = [[RJIterator alloc] initWithFunc:talk arg:@"乌卡卡"];
    r = [it next];
    NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    r = [it next];
    NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    r = [it next];
    NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    r = [it next];
    NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    r = [it next];
    NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    r = [it next];
    NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    r = [it next];
    NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    
    NSLog(@"************************ End %s *******************************", __func__);
}

- (NSNumber *)Fibonacci {
    int prev = 0;
    int cur = 1;
    for (;;) {
        rj_yield(@(cur));
        
        int p = prev;
        prev = cur;
        cur = p + cur;
        
        if (cur > 6765) {
            break;
        }
    }
    return @(cur);
}

+ (void)test2 {
    NSLog(@"************************ Begin %s *******************************", __func__);
    RJIterator *it = nil;
    RJResult *r = nil;
    
    it = [[RJIterator alloc] initWithTarget:[self new] selector:@selector(Fibonacci)];
    for (int i = 0; i < 22; ++i) {
        r = [it next];
        NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    }
    
    NSLog(@"************************ End %s *******************************", __func__);
}

//迭代器嵌套
- (id)dataBox:(NSString *)name age:(NSNumber *)age {
    NSLog(@"==in dataBox/enter");
    rj_yield([NSString stringWithFormat:@"Hello, I know you name:%@, age:%@, you want some data", name, age]);
    rj_yield(@"Fibonacci:");
    NSLog(@"==in dataBox/will return Fibonacci");
    rj_yield([[RJIterator alloc] initWithTarget:self selector:@selector(Fibonacci)]);
    rj_yield(@"Random Data:");
    NSLog(@"==in dataBox/will return Random Data");
    rj_yield(@"🐶");
    rj_yield([NSArray new]);
    rj_yield(@12345);
    rj_yield(self);
    return @"dataBox Over";
}

//更深嵌套
- (id)dataBox2:(NSString *)name age:(NSNumber *)age {
    rj_yield([[RJIterator alloc] initWithTarget:self selector:@selector(dataBox:age:), name, age]);
    
    NSLog(@"==in dataBox2/enter");
    rj_yield([NSString stringWithFormat:@"Hello, I know you name:%@, age:%@, you want some data", name, age]);
    rj_yield(@"Fibonacci:");
    NSLog(@"==in dataBox2/will return Fibonacci");
    rj_yield([[RJIterator alloc] initWithTarget:self selector:@selector(Fibonacci)]);
    rj_yield(@"Random Data:");
    NSLog(@"==in dataBox2/will return Random Data");
    rj_yield(@"🐶");
    rj_yield([NSArray new]);
    rj_yield(@12345);
    rj_yield(self);
    return @"dataBox2 Over";
}

+ (void)test3 {
    NSLog(@"************************ Begin %s *******************************", __func__);
    RJIterator *it = nil;
    RJResult *r = nil;
    
    it = [[RJIterator alloc] initWithTarget:[self new] selector:@selector(dataBox:age:), @"大表哥", @28];
    do {
        r = [it next];
        NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    }while(!r.done);
    
    NSLog(@"************************ End %s *******************************", __func__);
}

+ (void)test4 {
    NSLog(@"************************ Begin %s *******************************", __func__);
    RJIterator *it = nil;
    RJResult *r = nil;
    
    it = [[RJIterator alloc] initWithTarget:[self new] selector:@selector(dataBox2:age:), @"古德曼", @30];
    do {
        r = [it next];
        NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    }while(!r.done);
    
    NSLog(@"************************ End %s *******************************", __func__);
}

+ (void)test5 {
    NSLog(@"************************ Begin %s *******************************", __func__);
    RJIterator *it = nil;
    RJResult *r = nil;
    
    it = [[RJIterator alloc] initWithBlock:^{
        rj_yield(@100);
        rj_yield(@101);
        rj_yield(@102);
        rj_yield(@103);
    }];
    
    do {
        r = [it next];
        NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    }while(!r.done);
    
    NSLog(@"************************");
    
    it = [[RJIterator alloc] initWithBlock:^(NSString *name, NSNumber *age) {
        rj_yield([NSString stringWithFormat:@"Hello %@, your age is:%@", name, age]);
        rj_yield(@100);
        rj_yield(@101);
        rj_yield(@102);
        rj_yield(@103);
        NSLog(@"==in block/block done");
    }, @"索尔", @33];
    do {
        r = [it next];
        NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    }while(!r.done);
    
    NSLog(@"************************ End %s *******************************", __func__);
}

+ (void)test6 {
    NSLog(@"************************ Begin %s *******************************", __func__);
    RJIterator *it = nil;
    RJResult *r = nil;
    
    it = [[RJIterator alloc] initWithBlock:^(NSString *name, NSNumber *age) {
        rj_yield([NSString stringWithFormat:@"Hello %@, your age is:%@", name, age]);
        rj_yield(@100);
        rj_yield(@101);
        rj_yield(@102);
        rj_yield(@103);
        return @"i tell you : block done";
    }, @"索尔", @33];
    do {
        r = [it next];
        NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    }while(!r.done);
    
    NSLog(@"************************ End %s *******************************", __func__);
}

+ (NSNumber *)ClassFibonacci {
    int prev = 0;
    int cur = 1;
    for (;;) {
        rj_yield(@(cur));
        
        int p = prev;
        prev = cur;
        cur = p + cur;
        
        if (cur > 6765) {
            break;
        }
    }
    return @(cur);
}

+ (void)test7 {
    NSLog(@"************************ Begin %s *******************************", __func__);
    RJIterator *it = nil;
    RJResult *r = nil;
    
    it = [[RJIterator alloc] initWithTarget:self selector:@selector(ClassFibonacci)];
    for (int i = 0; i < 22; ++i) {
        r = [it next];
        NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    }
    
    NSLog(@"************************ End %s *******************************", __func__);
}

+ (void)talk2:(NSString *)name {
    NSString *really_name = rj_yield([NSString stringWithFormat:@"FakeName: %@", name]);
    NSLog(@"== talk2/really_name: %@", really_name);
}

+ (void)test8 {
    NSLog(@"************************ Begin %s *******************************", __func__);
    RJIterator *it = nil;
    RJResult *r = nil;
    
    it = [[RJIterator alloc] initWithTarget:self selector:@selector(talk2:), @"第一帅"];
    r = [it next];
    NSLog(@"== value: %@, done:%@", r.value, r.done ? @"YES" : @"NO");
    
    //为next传参,将在rj_yield返回前改变返回值， 即修改really_name
    r = [it next:@"RJK"]; //打印 RJK
    //如果不传参，将打印 //FakeName: 第一帅
    
    NSLog(@"************************ End %s *******************************", __func__);
}


+ (RJAsyncClosure)login:(NSString *)account pwd:(NSString *)pwd {
    return ^(RJAsyncCallback callback){
        NSLog(@"login with account:%@, pwd:%@", account, pwd);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            callback(@{@"uid": @"1001", @"token" : @"787767655"}, nil);
        });
    };
}

+ (RJAsyncClosure)query:(NSString *)uid token:(NSString *)token {
    return ^(RJAsyncCallback callback){
        NSLog(@"query with uid:%@, token:%@", uid, token);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            callback(@{@"headimg": @"http://xxx.jpg"}, nil);
        });
    };
}

+ (RJAsyncClosure)download:(NSString *)url {
    return ^(RJAsyncCallback callback){
        NSLog(@"download with url:%@", url);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            callback([UIImage new], nil);
        });
    };
}

+ (void)testAsync1 {
    rj_async(^{
        NSDictionary *login_json = rj_yield( [self login:@"123" pwd:@"123"] );
        NSLog(@"login_json : %@", login_json);
        NSDictionary *info_json = rj_yield( [self query:login_json[@"uid"] token:login_json[@"token"]] );
        NSLog(@"info_json : %@", info_json);
        UIImage *head_img = rj_yield( [self download:info_json[@"headimg"]] );
        NSLog(@"head_img: %@", head_img);
    })
    .error(^(id error) {
        NSLog(@"==testAsync1 error happen: %@", error);
    })
    .finally(^{
        NSLog(@"==testAsync1 finally");
    });
}

+ (RJAsyncClosure)queryError:(NSString *)uid token:(NSString *)token {
    return ^(RJAsyncCallback callback){
        NSLog(@"query with uid:%@, token:%@", uid, token);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            callback(nil, [NSError errorWithDomain:@"Query info Error" code:0 userInfo:nil]);
        });
    };
}

+ (void)testAsync2 {
    rj_async(^{
        NSDictionary *login_json = rj_yield( [self login:@"123" pwd:@"123"] );
        NSLog(@"login_json : %@", login_json);
        NSDictionary *info_json = rj_yield( [self queryError:login_json[@"uid"] token:login_json[@"token"]] );
        NSLog(@"info_json : %@", info_json);
        UIImage *head_img = rj_yield( [self download:info_json[@"headimg"]] );
        NSLog(@"head_img: %@", head_img);
    })
    .error(^(id error) {
        NSLog(@"==testAsync2 error happen: %@", error);
    })
    .finally(^{
        NSLog(@"==testAsync2 finally");
    });
}
@end
