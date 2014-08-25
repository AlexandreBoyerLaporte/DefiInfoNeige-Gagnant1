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

CREATE TABLE [dbo].[PushQueue]
(
	[ID] BIGINT NOT NULL PRIMARY KEY IDENTITY, 
    [UserID] INT NOT NULL, 
    [Message] NVARCHAR(50) NOT NULL, 
    [Type] TINYINT NOT NULL, 
    [AffectedID] INT NULL, 
    [Sent] TINYINT NOT NULL DEFAULT 0, 
    [DateAdded] DATETIME2 NOT NULL DEFAULT sysutcdatetime(),
    CONSTRAINT [FK_PushQueue_Users] FOREIGN KEY (UserID) REFERENCES Users(ID) ON DELETE CASCADE ON UPDATE CASCADE
)
