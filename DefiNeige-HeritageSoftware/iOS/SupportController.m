
//  This software is intended as a prototype for the Défi Info neige Contest.
//  Copyright (C) 2014 Heritage Software.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License
//
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.



#import "SupportController.h"
#import "StatusManager.h"


@interface SupportController ()

@end

@implementation SupportController


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *selected = [[self tableView] indexPathsForSelectedRows];
    
    for (NSIndexPath *indexPath in selected)
    {
        [[self tableView] deselectRowAtIndexPath:indexPath
                                        animated:YES];
    }
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger) tableView:(UITableView *)tableView
  numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = nil;
    
    if ([indexPath row] == 0)
    {
        identifier = @"1";
    }
    else if ([indexPath row] == 1)
    {
        identifier = @"2";
    }
    else if ([indexPath row] == 2)
    {
        identifier = @"3";
    }
    else if ([indexPath row] == 3)
    {
        identifier = @"4";
    }
    
    return [tableView dequeueReusableCellWithIdentifier:identifier
                                           forIndexPath:indexPath];
}


- (CGFloat) tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0)
    {
        return 1;
    }
    
    return 44;
}




- (void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0)
    {
        
    }
    else if ([indexPath row] == 1)
    {
        if ([MFMailComposeViewController canSendMail])
        {
            MFMailComposeViewController *composerController = [[MFMailComposeViewController alloc] init];
            
            [composerController setToRecipients:@[@"alex@heritagesofteware.ca"]];
            
            [composerController setSubject:@"Défi Info Neige"];
            
            [composerController setMailComposeDelegate:self];
            
            [self presentViewController:composerController
                               animated:YES
                             completion:nil];
            
        }
    }
    else if ([indexPath row] == 2)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"311"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Annuler"
                                                  otherButtonTitles:@"Appeler", nil];
        
        [alertView setTag:1];
        
        [alertView show];
    }
    else if ([indexPath row] == 3)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"514-872-3777"
                                                            message:@"Remorquage"
                                                           delegate:self
                                                  cancelButtonTitle:@"Annuler"
                                                  otherButtonTitles:@"Appeler", nil];
        [alertView setTag:2];
        [alertView show];
    }
}

- (IBAction)dismissController:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES
                                   completion:nil];
}

- (void) alertView:(UIAlertView *)alertView
willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 1 && [alertView cancelButtonIndex] != buttonIndex)
    {
        NSString *phoneNumber = @"tel://311";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
    }
    else if ([alertView tag] == [alertView cancelButtonIndex] != buttonIndex)
    {
        NSString *phoneNumber = @"tel://5148723777";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
 
    }
    NSArray *selected = [[self tableView] indexPathsForSelectedRows];
    
    for (NSIndexPath *indexPath in selected)
    {
        [[self tableView] deselectRowAtIndexPath:indexPath
                                        animated:YES];
    }
}

@end
