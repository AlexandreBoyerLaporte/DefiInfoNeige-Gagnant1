
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




#import "InfoController.h"
#import "InfoCell.h"
#import "StatusManager.h"

@interface InfoController ()

@end

@implementation InfoController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIImage *_maskingImage = [UIImage imageNamed:@"Montreal"];
    CALayer *_maskingLayer = [CALayer layer];
    _maskingLayer.frame = CGRectMake(0,-75, 305, 150);
    [_maskingLayer setContents:(id)[_maskingImage CGImage]];
    [[self progressView].layer setMask:_maskingLayer];
    [[self progressView] setProgress:0];

    [[self progressLabel] setText:[NSString stringWithFormat:@"0%%"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [StatusManager percentageOfClearedRoadSidesWithCompletion:^(NSInteger percentSnowRemoved, NSError *error)
    {
        
        [self setProgress:((float)percentSnowRemoved)/100.f];
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.01
                                                 target:self
                                               selector:@selector(timerDidFire:)
                                               userInfo:nil
                                                repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:timer
                                     forMode:NSDefaultRunLoopMode];
    }];
 
}


- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger) collectionView:(UICollectionView *)collectionView
      numberOfItemsInSection:(NSInteger)section
{
    return 3;
}


- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView
                   cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    InfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InfoCellIdentifier"
                                                               forIndexPath:indexPath];
    
    if ([indexPath row] == 0)
    {
        [[cell infoImageView] setImage:[UIImage imageNamed:@"cloudy_snow_accumul"]];
        [[cell statusTitleLabel] setText:@"Dernier 24h"];
        [[cell statusValueLabel] setText:@"0cm"];
        [[cell frontSeparatorImageView] setHidden:YES];
        [[cell separatorImageView] setHidden:NO];
    }
    else if ([indexPath row] == 1)
    {
        [[cell infoImageView] setImage:[UIImage imageNamed:@"precipitations"]];
        [[cell statusTitleLabel] setText:@"P.D.A"];
        [[cell statusValueLabel] setText:@"0%"];
        [[cell frontSeparatorImageView] setHidden:YES];
        [[cell separatorImageView] setHidden:YES];
    }
    else if ([indexPath row] == 2)
    {
        [[cell infoImageView] setImage:[UIImage imageNamed:@"cloudy_snow_precip"]];
        [[cell statusTitleLabel] setText:@"Prochain 24h"];
        [[cell statusValueLabel] setText:@"0cm"];
        [[cell frontSeparatorImageView] setHidden:NO];
        [[cell separatorImageView] setHidden:YES];
    }
    
    return cell;
}





- (IBAction)dismissController:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

     
- (void) timerDidFire:(NSTimer *)timer
{
    if ([[self progressView] progress] >= [self progress])
    {
        [timer invalidate];

    }
    else
    {
        float currentProgress = [[self progressView] progress];
        
        currentProgress += 0.01;
        
        [[self progressView] setProgress:currentProgress
                                animated:YES];
        
        [[self progressLabel] setText:[NSString stringWithFormat:@"%d\%%",(int)(currentProgress * 100.f)]];
    }
}


@end
