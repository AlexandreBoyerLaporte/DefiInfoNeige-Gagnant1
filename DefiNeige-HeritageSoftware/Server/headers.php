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

require_once dirname(__FILE__) . '/config.php';

require_once dirname(__FILE__) . '/classes/DBHanlder.php';
require_once dirname(__FILE__) . '/classes/DBInteractor.php';
require_once dirname(__FILE__) . '/classes/DataTransferer.php';
require_once dirname(__FILE__) . '/classes/GeoPointConverter.php';
require_once dirname(__FILE__) . '/classes/RoadCenterCalculator.php';
require_once dirname(__FILE__) . '/classes/CityAPIHandler.php';
require_once dirname(__FILE__) . '/classes/AbstractRoad.php';
require_once dirname(__FILE__) . '/classes/Road.php';
require_once dirname(__FILE__) . '/classes/RoadSide.php';
require_once dirname(__FILE__) . '/classes/GeoPoint.php';
require_once dirname(__FILE__) . '/classes/PushQueueFeeder.php';
require_once dirname(__FILE__) . '/classes/NotificationUtility.php';
require_once dirname(__FILE__) . '/classes/PushQueueHandler.php';

require_once dirname(__FILE__) . '/classes/MapRoadSideGetter.php';
require_once dirname(__FILE__) . '/classes/UserActionManager.php';
require_once dirname(__FILE__) . '/classes/UpdateManager.php';
require_once dirname(__FILE__) . '/classes/StatusGetter.php';