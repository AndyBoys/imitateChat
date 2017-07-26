//
//  ViewController.m
//  imitateChatDemo
//
//  Created by Lesogo_A1 on 2017/7/26.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import "ViewController.h"
#import "IMContactViewController.h"



@interface ViewController ()

@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)showChat:(UIBarButtonItem *)sender {
    
    IMContactViewController *IMChatVC = [[IMContactViewController alloc] init];
    [self.navigationController pushViewController:IMChatVC animated:YES];
    
}



@end
