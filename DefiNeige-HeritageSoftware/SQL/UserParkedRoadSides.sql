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

CREATE TABLE [dbo].[UserParkedRoadSides]
(
	[UserID] INT NOT NULL, 
    [RoadSideID] INT NOT NULL, 
    [DateAdded] DATETIME2 NOT NULL DEFAULT sysutcdatetime(),
    CONSTRAINT [PrimaryKey_UserParkedRoadSides] PRIMARY KEY CLUSTERED ([UserID] ASC, RoadSideID ASC), 
    CONSTRAINT [FK_UserParkedRoadSides_Users] FOREIGN KEY (UserID) REFERENCES Users(ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_UserParkedRoadSides_RoadSides] FOREIGN KEY (RoadSideID) REFERENCES RoadSides(ID) ON DELETE CASCADE ON UPDATE CASCADE
)
