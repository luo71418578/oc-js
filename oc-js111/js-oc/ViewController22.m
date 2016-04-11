//
//  ViewController22.m
//  js-oc
//
//  Created by luo on 16/4/7.
//  Copyright © 2016年 vcredit. All rights reserved.
//

#import "ViewController22.h"
#import "ViewController.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface ViewController22 ()

@end

@implementation ViewController22

- (void)viewDidLoad {
    [super viewDidLoad];
    
    unsigned int count;
    Ivar *ivars = class_copyIvarList([UIViewController class], &count);
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        //根据ivar获得其成员变量的名称
        const char *name = ivar_getName(ivar);
        //C的字符串转OC的字符串
        NSString *key = [NSString stringWithUTF8String:name];
        NSLog(@"%d == %@",i,key);
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
