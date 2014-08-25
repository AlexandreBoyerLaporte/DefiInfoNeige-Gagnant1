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

require_once 'run_config.php';

global $runCallAbsLoc, $jobIsRunnable, $currentJobType;

$runCallAbsPath = $runCallAbsLoc . "run_call.php";
require_once $runCallAbsPath;

if (!$jobIsRunnable)
{
    die("Job is not runnable");
}

if ($currentJobType == JOB_TYPE_TRANSFER)
{
    transferJob();
}
else if ($currentJobType == JOB_TYPE_CONVERT)
{
    convertJob();
}
else if ($currentJobType == JOB_TYPE_ROAD_CENTERS)
{
    roadCentersJob();
}
else if ($currentJobType == JOB_TYPE_API_PULL)
{
    cityAPIPullJob();
}
else if ($currentJobType == JOB_TYPE_PUSH_FEEDER)
{
    pushFeederJob();
}
else if ($currentJobType == JOB_TYPE_PUSH)
{
    pushJob();
}