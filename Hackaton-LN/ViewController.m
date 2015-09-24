//
//  ViewController.m
//  Hackaton-LN
//
//  Created by Carlos Garcia on 21/9/15.
//  Copyright (c) 2015 Carlos Garcia. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "NoticiaAvance.h"
#import "NoteViewController.h"

static NSString * const NOTAS_URL = @"http://contenidos.lanacion.com.ar/json/acumulado-ultimas";
static NSString * const CELL_IDENTIFIER = @"cellIdentifier";


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self cargarNoticias];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELL_IDENTIFIER];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.navigationItem setTitle:@"Hackaton LN"];
}

-(void)cargarNoticias{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSDictionary *parameters = @{@"foo": @"bar"};
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
    [manager POST:NOTAS_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        NSArray* notas = [json objectForKey:@"items"];
        if(!self.noticias)self.noticias = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in notas) {
            NoticiaAvance * noticia = [[NoticiaAvance alloc] initWithAtributos:dic];
            [self.noticias addObject:noticia];
        }
        [self.tableView reloadData];
        
        NSLog(@"notas: %lu", (unsigned long)notas.count);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.noticias.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_IDENTIFIER];
    
    
    NoticiaAvance * noticia = [self.noticias objectAtIndex: indexPath.row];
    
    [cell.textLabel setText:[noticia titulo]];
    [cell.detailTextLabel setText:[noticia bajada]];
    
    [cell.textLabel setNumberOfLines:0];
    [cell.detailTextLabel setNumberOfLines:0];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return  cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 140;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticiaAvance * noti = [self.noticias objectAtIndex:indexPath.row];
    [self showNotaForNoticia:[noti notaId]];
}
-(void)showNotaForNoticia:(NSString *)noticiaAvance{
    NoteViewController *nota = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"noteViewController"];
    nota.noteId = noticiaAvance;
    [self.navigationController pushViewController:nota animated:YES];
}

@end
