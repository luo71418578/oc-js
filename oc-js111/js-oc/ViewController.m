//
//  ViewController.m
//  js-oc
//
//  Created by luo on 16/4/6.
//  Copyright © 2016年 vcredit. All rights reserved.
//

#import "ViewController.h"
#import "OpenSSLRSAWrapper.h"
#include <openssl/opensslv.h>
#include <openssl/rsa.h>
#include <openssl/evp.h>
#include <openssl/bn.h>
#import "NSData+Base64.h"
#import "ViewController22.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIWebView *webView1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _webView1 = [[UIWebView alloc]init];
//    _webView1.backgroundColor = [UIColor clearColor];
    //webview.scalesPageToFit =YES;
//    _webView1.delegate =self;
//    [self.view addSubview:_webView1];
    //找到jsIOS.html文件的路径
    NSString *basePath = [[NSBundle mainBundle]bundlePath];
    NSString *helpHtmlPath = [basePath stringByAppendingPathComponent:@"jsIOS.html"];
    NSURL *url = [NSURL fileURLWithPath:helpHtmlPath];
    //加载本地html文件
    [_webView1 loadRequest:[NSURLRequest requestWithURL:url]];
    
    
}


- (IBAction)clickButton:(id)sender {
    
//    formatToHex(b, a, model, exponent)
    
    
    NSString *number = @"414123123123123";
    NSString *password = @"123456";
    NSString *content = @"10001";
    NSString *str1 = @"ddc1b17fe4c89d81461d885b81b261f16ce20e5170810f87319fa34233b437aa33c71fc111aa9256af607b997c51ba5cf6f537fa75ad7425c32049e9443082756e002c966bdf82a9febae17369faf215c7d82baa8afd973ac92ba8d33eb779ec024dba1a451805b47510237c5e5901da59e7a818896160a76cd32171a35e8034307a9828118c318745499dc491186c2748f225e6817a9d959ac143b4e0e5896d17e53f9c4a03e7d7ecf3947c2ed6cbe6058c61dd9a44637844c11f0a4308dae5de5bd24519e5e09ea60f4ec81f32f8ae8fe55c4237c607c15b17158cf5ae91268c6a76a8e6ced80fafc8969a09db41dc07a9a6c18bc060885d0fede70ca33aa1";
//    NSString *str = [_webView1 stringByEvaluatingJavaScriptFromString:@"formatToHex('4242414252563363673','123456','10001','qweqewewq');"];
    NSString *str = [_webView1 stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"formatToHex('%@','%@','%@','%@');",password,number,str1,content]];
    NSLog(@"JS返回值：%@",str);
}



//另一种RSA加密方法
- (RSA *)rsaFromExponent:(NSString *)exponent modulus:(NSString *)modulus
{
    RSA *rsa_pub = RSA_new();
    
    const char *N = [modulus UTF8String];
    const char *E = [exponent UTF8String];
    
    if (!BN_hex2bn(&rsa_pub->n, N))
    {
        // TODO
    }
    printf("N: %s\n", N);
    printf("n: %s\n", BN_bn2dec(rsa_pub->n));
    
    if (!BN_hex2bn(&rsa_pub->e, E))
    {
        // TODO
    }
    printf("E: %s\n", E);
    printf("e: %s\n", BN_bn2dec(rsa_pub->e));
    
    return rsa_pub;
}


-(NSString *)encrptCode
{
    RSA *rsa_1 = [self rsaFromExponent:@"10001" modulus:@"ddc1b17fe4c89d81461d885b81b261f16ce20e5170810f87319fa34233b437aa33c71fc111aa9256af607b997c51ba5cf6f537fa75ad7425c32049e9443082756e002c966bdf82a9febae17369faf215c7d82baa8afd973ac92ba8d33eb779ec024dba1a451805b47510237c5e5901da59e7a818896160a76cd32171a35e8034307a9828118c318745499dc491186c2748f225e6817a9d959ac143b4e0e5896d17e53f9c4a03e7d7ecf3947c2ed6cbe6058c61dd9a44637844c11f0a4308dae5de5bd24519e5e09ea60f4ec81f32f8ae8fe55c4237c607c15b17158cf5ae91268c6a76a8e6ced80fafc8969a09db41dc07a9a6c18bc060885d0fede70ca33aa1"];
    NSString *user = @"414253616172738";
    NSData *userData = [user dataUsingEncoding:NSASCIIStringEncoding];
    NSString *userB64String = [userData base64EncodedString];
    
    // 4. encrypt
    const unsigned char *from = (const unsigned char *)[userB64String cStringUsingEncoding:NSASCIIStringEncoding];
    int flen = strlen((const char *)from);
    unsigned char *to = (unsigned char *) malloc(RSA_size(rsa_1));
    int padding = RSA_PKCS1_PADDING;
    int result = RSA_public_encrypt(flen, from, to, rsa_1, padding);
    if (-1 == result)
    {
        NSLog(@"WAT?");
    }
    else
    {
        NSLog(@"from: %s", from); // echo VEVTVA==
        NSLog(@"to: %s", to); // echo something strange with characters like: ~™Ÿû—...
    }
    
    // 5. encode base 64
    NSData *cipherData = [NSData dataWithBytes:(const void *)to length:result];
    //    NSString *strdata = [[NSString alloc]initWithData:cipherData encoding:NSUTF8StringEncoding];
    
    NSString *cipherDataB64 = [cipherData base64EncodedString];
    
    NSLog(@"user encrypted b64: %@", cipherDataB64); // now echo the
    
    return cipherDataB64;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ViewController22 *view = [[ViewController22 alloc]init];
    [self.navigationController pushViewController:view animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
