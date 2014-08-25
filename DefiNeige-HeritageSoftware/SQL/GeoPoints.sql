--
--  This software is intended as a prototype for the Défi Info neige Contest.
--  Copyright (C) 2014 Heritage Software.
--
--  This program is free software: you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation, either version 3 of the License
--
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program.  If not, see <http://www.gnu.org/licenses/
--

CREATE TABLE [dbo].[GeoPoints]
(
	[ID] INT NOT NULL PRIMARY KEY IDENTITY,
    [RoadID] INT NULL, 
	[RoadSideID] INT NULL,
    [X] FLOAT NOT NULL, 
    [Y] FLOAT NOT NULL, 
    [Longitude] FLOAT NULL, 
    [Latitude] FLOAT NULL,
    CONSTRAINT [FK_GeoPoints_Roads] FOREIGN KEY (RoadID) REFERENCES Roads(ID) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT [FK_GeoPoints_RoadSides] FOREIGN KEY (RoadSideID) REFERENCES RoadSides(ID) ON UPDATE CASCADE ON DELETE CASCADE
)
