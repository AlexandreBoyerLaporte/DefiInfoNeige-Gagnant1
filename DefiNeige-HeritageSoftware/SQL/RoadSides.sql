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

CREATE TABLE [dbo].[RoadSides]
(
	[ID] INT NOT NULL PRIMARY KEY, 
    [RoadID] INT NOT NULL, 
    [StartAddress] INT NOT NULL, 
    [EndAddress] INT NOT NULL, 
    [Orientation] NVARCHAR(100) NULL, 
    [StreetName] NVARCHAR(100) NOT NULL, 
    [LienF] NVARCHAR(100) NULL, 
    [Borough] NVARCHAR(100) NOT NULL, 
    [Type] NVARCHAR(20) NOT NULL, 
    [RoadStatus] TINYINT NOT NULL DEFAULT 1, 
    [DatePlannedStart] DATETIME2 NULL, 
    [DatePlannedEnd] DATETIME2 NULL, 
    [DateReplannedStart] DATETIME2 NULL, 
    [DateReplannedEnd] DATETIME2 NULL, 
    [DateLastPlanned] DATETIME2 NULL
)
