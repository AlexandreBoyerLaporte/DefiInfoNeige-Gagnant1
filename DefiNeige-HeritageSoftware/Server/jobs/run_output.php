<?php
//
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
//  along with this program.  If not, see <http://www.gnu.org/licenses/
//

//
// Output is used with conversion tool http://leware.net/geo/utmgoogle.htm
//

require_once '../headers.php';
require_once 'run_config.php';

header('Content-type: text/plain');

if (!$jobIsRunnable)
{
    die("Job is not runnable");
}

$geoPointConverter = new GeoPointConverter();
$geoPointConverter->outputMTMGeoPoints();

