!classDefinition: #MarsRoverLogTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverLogTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 14:40:43'!
assertLog: aLog hasValue: aValue atIndex: anIndex
	
	self assert: ((aLog at: anIndex) at: 1) = aValue.
	
	! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 15:17:10'!
assertWindow: aWindow hasValue: aValue at: aKey

	self assert: (aWindow at: aKey) = aValue.! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 14:44:56'!
east

	^ MarsRoverHeadingEast! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 14:44:58'!
north

	^ MarsRoverHeadingNorth! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 14:45:02'!
south

	^ MarsRoverHeadingSouth! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 14:41:12'!
test01seLogeaElPrimeroMovimiento

	| marsRover initialPosition log |
	
	initialPosition := MarsRoverPosition at: 1@1.

	marsRover := (MarsRover 
		at: initialPosition
		heading: self north).
		
	log := MarsRoverLog new.
	log registerFor: initialPosition withName: #Position.
		
	marsRover process: 'f'.
	
	self assertLog: log hasValue: (1@2) atIndex: 1.
	
	! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 14:45:53'!
test02seLogeaElSegundoMovimiento

	| marsRover initialPosition log |
	
	initialPosition := MarsRoverPosition at: 1@1.

	marsRover := (MarsRover 
		at: initialPosition
		heading: self north).
		
	log := MarsRoverLog new.
	log registerFor: initialPosition withName: #Position.
		
	marsRover process: 'ff'.
	
	self assertLog: log hasValue: (1@2) atIndex: 1.
	self assertLog: log hasValue: (1@3) atIndex: 2.
	! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 14:46:06'!
test03seLogeaUnCambioDeDireccion

	| marsRover initialHeading log |
	
	initialHeading := MarsRoverHead towards: 	MarsRoverHeadingNorth.

	marsRover := (MarsRover 
		at: (MarsRoverPosition at: 1@1)
		heading: initialHeading).
		
	log := MarsRoverLog new.
	log registerFor: initialHeading withName: #Heading.
		
	marsRover process: 'r'.
	
	self assertLog: log hasValue: (self east new) atIndex: 1.
	
	! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 14:46:35'!
test04seLogeaElSegundoCambioDeDireccion

	| marsRover initialHeading log |
	
	initialHeading := MarsRoverHead towards: 	MarsRoverHeadingNorth.

	marsRover := (MarsRover 
		at: (MarsRoverPosition at: 1@1)
		heading: initialHeading).
		
	log := MarsRoverLog new.
	log registerFor: initialHeading withName: #Heading.
		
	marsRover process: 'rl'.
	
	self assertLog: log hasValue: (self east new) atIndex: 1.
	self assertLog: log hasValue: (self north new) atIndex: 2.
	
	! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 14:47:05'!
test05seLogeanLaPosicionYLaDireccionEnSimultaneo

	| marsRover initialPosition initialHeading log |
	
	initialPosition := MarsRoverPosition at: (1@1).
	initialHeading := MarsRoverHead towards: 	MarsRoverHeadingNorth.

	marsRover := (MarsRover 
		at: initialPosition
		heading: initialHeading).
		
	log := MarsRoverLog new.
	log registerFor: initialHeading withName: #Heading.
	log registerFor: initialPosition withName: #Position.
		
	marsRover process: 'fr'.
	
	self assertLog: log hasValue: (1@2) atIndex: 1.
	self assertLog: log hasValue: (self east new) atIndex: 2.
	
	! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 15:17:51'!
test06seMuestraElPrimerMovimiento

	| marsRover initialPosition window |
	
	initialPosition := MarsRoverPosition at: (1@1).

	marsRover := (MarsRover 
		at: initialPosition
		heading: self north).
		
	window := MarsRoverLogWindow new.
	window registerFor: initialPosition withName: #Position.
	
	marsRover process: 'f'.
	
	self assertWindow: window hasValue: (1@2) at: #Position.
	
	! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 15:17:43'!
test07seMuestranEnSecuenciaDeDosMovimientos

	| marsRover initialPosition window |
	
	initialPosition := MarsRoverPosition at: (1@1).

	marsRover := (MarsRover 
		at: initialPosition
		heading: self north).
		
	window := MarsRoverLogWindow new.
	window registerFor: initialPosition withName: #Position.
	
	marsRover process: 'f'.
	
	self assertWindow: window hasValue: (1@2) at: #Position.
	
	marsRover process: 'f'.
	
	self assertWindow: window hasValue: (1@3) at: #Position.
	
	! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 15:18:14'!
test08seMuestraUnCambioDeRotacion

	| marsRover initialHeading window |
	
	initialHeading := MarsRoverHead towards: 	MarsRoverHeadingNorth.

	marsRover := (MarsRover 
		at: (MarsRoverPosition at: 1@1)
		heading: initialHeading).
		
	window := MarsRoverLogWindow new.
	window registerFor: initialHeading withName: #Heading.
		
	marsRover process: 'r'.
	
	self assertWindow: window hasValue: (self east new) at: #Heading.
	! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 15:22:05'!
test09seMuestranElPrimeroMovimientoYRotacion

	| marsRover initialHeading initialPosition window |
	
	initialHeading := MarsRoverHead towards: 	MarsRoverHeadingNorth.
	initialPosition := MarsRoverPosition at: (1@1).

	marsRover := (MarsRover 
		at: initialPosition
		heading: initialHeading).
		
	window := MarsRoverLogWindow new.
	window registerFor: initialPosition withName: #Position.
	window registerFor: initialHeading withName: #Heading.
		
	marsRover process: 'fr'.
	
	self assertWindow: window hasValue: (1@2) at: #Position.
	self assertWindow: window hasValue: (self east new) at: #Heading.
	! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 15:24:10'!
test10seMuestranTodosLosCambiosEnSecuencia

	| marsRover initialHeading initialPosition window |
	
	initialHeading := MarsRoverHead towards: 	MarsRoverHeadingNorth.
	initialPosition := MarsRoverPosition at: (1@1).

	marsRover := (MarsRover 
		at: initialPosition
		heading: initialHeading).
		
	window := MarsRoverLogWindow new.
	window registerFor: initialPosition withName: #Position.
	window registerFor: initialHeading withName: #Heading.
		
	marsRover process: 'f'.
	
	self assertWindow: window hasValue: (1@2) at: #Position.
	self assertWindow: window hasValue: 'Nada' at: #Heading.
	
	marsRover process: 'r'.
	
	self assertWindow: window hasValue: (1@2) at: #Position.
	self assertWindow: window hasValue: (self east new) at: #Heading.
	
	marsRover process: 'f'.
	
	self assertWindow: window hasValue: (2@2) at: #Position.
	self assertWindow: window hasValue: (self east new) at: #Heading.
	
	! !

!MarsRoverLogTest methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 14:45:06'!
west

	^ MarsRoverHeadingWest! !


!classDefinition: #MarsRoverTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:21:23'!
test01DoesNotMoveWhenNoCommand

	self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: '' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:12'!
test02IsAtFailsForDifferentPosition

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@2 heading: self north)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:31'!
test03IsAtFailsForDifferentHeading

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@1 heading: self south)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:17'!
test04IncrementsYAfterMovingForwardWhenHeadingNorth

	self 
		assertIsAt: 1@3 
		heading: self north 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:11'!
test06DecrementsYAfterMovingBackwardsWhenHeadingNorth

	self 
		assertIsAt: 1@1 
		heading: self north 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:59'!
test07PointToEashAfterRotatingRightWhenHeadingNorth

	self 
		assertIsAt: 1@2 
		heading: self east 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:51'!
test08PointsToWestAfterRotatingLeftWhenPointingNorth

	self 
		assertIsAt: 1@2 
		heading: self west 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:45'!
test09DoesNotProcessInvalidCommand

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: self north.
	
	self 
		should: [ marsRover process: 'x' ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: marsRover invalidCommandErrorDescription.
			self assert: (marsRover isAt: 1@2 heading: self north) ]! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:39'!
test10CanProcessMoreThanOneCommand

	self 
		assertIsAt: 1@4 
		heading: self north 
		afterProcessing: 'ff' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:31'!
test11IncrementsXAfterMovingForwareWhenHeadingEast

	self 
		assertIsAt: 2@2 
		heading: self east 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:19'!
test12DecrementsXAfterMovingBackwardWhenHeadingEast

	self 
		assertIsAt: 0@2 
		heading: self east 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:14'!
test13PointsToSouthAfterRotatingRightWhenHeadingEast

		self 
		assertIsAt: 1@2 
		heading: self south 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:05'!
test14PointsToNorthAfterRotatingLeftWhenPointingEast

		self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:00'!
test15ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingSouth

	self 
		assertIsAt: 1@1 
		heading: self west 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self south 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:52'!
test16ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingWest

	self 
		assertIsAt: 0@2 
		heading: self north 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self west 
! !


!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:31'!
east

	^ MarsRoverHeadingEast ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:38'!
north

	^ MarsRoverHeadingNorth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:45'!
south

	^ MarsRoverHeadingSouth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:54'!
west

	^ MarsRoverHeadingWest ! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'BK 10/29/2023 19:49:17'!
assertIsAt: newPosition heading: newHeadingType afterProcessing: commands whenStartingAt: startPosition heading: startHeadingType

	| marsRover startPositionProxy startHeadingTypeProxy |
	
	startPositionProxy := MarsRoverPosition at: startPosition.
	startHeadingTypeProxy := MarsRoverHead towards: startHeadingType.
	
	marsRover := MarsRover at: startPositionProxy heading: startHeadingTypeProxy. 
	
	marsRover process: commands.
	
	self assert: (marsRover isAt: newPosition heading: newHeadingType)! !


!classDefinition: #MarsRover category: 'MarsRover-WithHeading'!
Object subclass: #MarsRover
	instanceVariableNames: 'position head'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:48:45'!
invalidCommandErrorDescription
	
	^'Invalid command'! !

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:50:26'!
signalInvalidCommand
	
	self error: self invalidCommandErrorDescription ! !


!MarsRover methodsFor: 'initialization' stamp: 'BK 10/29/2023 19:36:49'!
initializeAt: aPosition heading: aHeadingType

	position := aPosition.
	head := aHeadingType for: self.! !


!MarsRover methodsFor: 'heading' stamp: 'BK 10/29/2023 19:23:08'!
headEast
	
	head := head headEastFor: self.! !

!MarsRover methodsFor: 'heading' stamp: 'BK 10/29/2023 19:25:00'!
headNorth
	
	head := head headNorthFor: self.! !

!MarsRover methodsFor: 'heading' stamp: 'BK 10/29/2023 19:25:08'!
headSouth
	
	head := head headSouthFor: self.! !

!MarsRover methodsFor: 'heading' stamp: 'BK 10/29/2023 19:25:18'!
headWest
	
	head := head headWestFor: self.! !

!MarsRover methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	head rotateLeft! !

!MarsRover methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	head rotateRight! !


!MarsRover methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:16:32'!
isAt: aPosition heading: aHeadingType

	^position = aPosition and: [ head isHeading: aHeadingType ]! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:51'!
isBackwardCommand: aCommand

	^aCommand = $b! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:19'!
isForwardCommand: aCommand

	^aCommand = $f ! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:51'!
isRotateLeftCommand: aCommand

	^aCommand = $l! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:21'!
isRotateRightCommand: aCommand

	^aCommand = $r! !


!MarsRover methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	head moveBackward! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:15:01'!
moveEast
	
	position := position + (1@0)! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	head moveForward! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:13:12'!
moveNorth
	
	position := position + (0@1)! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:13:34'!
moveSouth
	
	position := position + (0@-1)! !

!MarsRover methodsFor: 'moving' stamp: 'HAW 8/22/2019 12:15:32'!
moveWest
	
	position := position + (-1@0)! !


!MarsRover methodsFor: 'command processing' stamp: 'HAW 6/30/2018 19:48:26'!
process: aSequenceOfCommands

	aSequenceOfCommands do: [:aCommand | self processCommand: aCommand ]
! !

!MarsRover methodsFor: 'command processing' stamp: 'HAW 8/22/2019 12:08:50'!
processCommand: aCommand

	(self isForwardCommand: aCommand) ifTrue: [ ^ self moveForward ].
	(self isBackwardCommand: aCommand) ifTrue: [ ^ self moveBackward ].
	(self isRotateRightCommand: aCommand) ifTrue: [ ^ self rotateRight ].
	(self isRotateLeftCommand: aCommand) ifTrue: [ ^ self rotateLeft ].

	self signalInvalidCommand.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover-WithHeading'!
MarsRover class
	instanceVariableNames: 'headings'!

!MarsRover class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:10:30'!
at: aPosition heading: aHeadingType
	
	^self new initializeAt: aPosition heading: aHeadingType! !


!classDefinition: #MarsRoverHeading category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverHeading
	instanceVariableNames: 'marsRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeading methodsFor: 'heading' stamp: 'BK 10/30/2023 14:39:56'!
= aHeading

	^ self name = aHeading name! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'BK 10/30/2023 14:22:11'!
name

	^ self subclassResponsibility.! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:15:38'!
isHeading: aHeadingType

	^self isKindOf: aHeadingType ! !


!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'initialization' stamp: 'HAW 10/7/2021 20:11:59'!
initializeFor: aMarsRover 
	
	marsRover := aMarsRover.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeading class' category: 'MarsRover-WithHeading'!
MarsRoverHeading class
	instanceVariableNames: ''!

!MarsRoverHeading class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:11:35'!
for: aMarsRover 
	
	^self new initializeFor: aMarsRover ! !


!classDefinition: #MarsRoverHeadingEast category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingEast
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveWest! !

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveEast! !


!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'BK 10/30/2023 14:22:00'!
name

	^ 'East'! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headNorth! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headSouth! !


!classDefinition: #MarsRoverHeadingNorth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingNorth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveSouth! !

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveNorth! !


!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'BK 10/30/2023 14:22:19'!
name

	^ 'North'! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headWest! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headEast! !


!classDefinition: #MarsRoverHeadingSouth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingSouth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveNorth! !

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveSouth! !


!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'BK 10/30/2023 14:22:26'!
name

	^ 'South'! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headEast! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headWest! !


!classDefinition: #MarsRoverHeadingWest category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingWest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	^marsRover moveEast! !

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveWest! !


!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'BK 10/30/2023 14:22:33'!
name

	^ 'West'! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headSouth! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headNorth! !


!classDefinition: #MarsRoverLog category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverLog
	instanceVariableNames: 'log'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLog methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 21:09:19'!
at: anIndex

	^log at: anIndex.! !

!MarsRoverLog methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 19:58:58'!
initialize

	log := OrderedCollection new.! !

!MarsRoverLog methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 20:59:28'!
registerFor: aProxy withName: logName

	aProxy register: [:newValue |	
		log add: (Array with: newValue with: logName).
	].! !


!classDefinition: #MarsRoverLogWindow category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverLogWindow
	instanceVariableNames: 'textbox'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLogWindow methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 15:33:43'!
asString

	| string |

	textbox do: [ :value | string := string, 'POTATO' ].! !

!MarsRoverLogWindow methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 15:23:18'!
at: logName

	^ textbox at: logName ifAbsent: [ 'Nada' ].! !

!MarsRoverLogWindow methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 15:12:05'!
initialize

	textbox := Dictionary new.! !

!MarsRoverLogWindow methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 15:06:07'!
registerFor: aProxy withName: logName

	aProxy register: [:newValue |	
		textbox add: logName -> newValue.
	].! !


!classDefinition: #MarsRoverProxies category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverProxies
	instanceVariableNames: 'listeners'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverProxies methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 21:01:27'!
initialize

	listeners := OrderedCollection new.! !

!MarsRoverProxies methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 21:05:21'!
log: aValue

	listeners do: [ :listener | listener value: aValue ].! !

!MarsRoverProxies methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 21:00:40'!
register: aListener

	listeners add: aListener.! !


!classDefinition: #MarsRoverHead category: 'MarsRover-WithHeading'!
MarsRoverProxies subclass: #MarsRoverHead
	instanceVariableNames: 'head'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHead methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 19:39:36'!
for: aMarsRover

	head := head for: aMarsRover.! !

!MarsRoverHead methodsFor: 'as yet unclassified' stamp: 'BK 10/30/2023 14:20:07'!
headEastFor: aMarsRover

	head := MarsRoverHeadingEast for: aMarsRover.
	self log: head.! !

!MarsRoverHead methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 21:07:19'!
headNorthFor: aMarsRover

	head := MarsRoverHeadingNorth for: aMarsRover.
	self log: head.! !

!MarsRoverHead methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 21:07:21'!
headSouthFor: aMarsRover

	head := MarsRoverHeadingSouth for: aMarsRover.
	self log: head.! !

!MarsRoverHead methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 21:07:23'!
headWestFor: aMarsRover

	head := MarsRoverHeadingWest for: aMarsRover.
	self log: head.! !

!MarsRoverHead methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 21:01:00'!
initializeWith: aHeading

	head := aHeading.! !

!MarsRoverHead methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 19:48:57'!
isHeading: aHeadingType

	^ head isHeading: aHeadingType.! !

!MarsRoverHead methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 19:53:12'!
moveBackward.

	^ head moveBackward.! !

!MarsRoverHead methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 19:53:07'!
moveForward

	^ head moveForward.! !

!MarsRoverHead methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 19:54:59'!
rotateLeft

	^ head rotateLeft.! !

!MarsRoverHead methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 19:54:54'!
rotateRight

	^ head rotateRight.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHead class' category: 'MarsRover-WithHeading'!
MarsRoverHead class
	instanceVariableNames: ''!

!MarsRoverHead class methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 19:19:38'!
towards: aHeading

	^ self new initializeWith: aHeading.! !


!classDefinition: #MarsRoverPosition category: 'MarsRover-WithHeading'!
MarsRoverProxies subclass: #MarsRoverPosition
	instanceVariableNames: 'position'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverPosition methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 21:02:08'!
+ aTranslation

	position := position + aTranslation.
	
	self log: position.
	
	^ self.! !

!MarsRoverPosition methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 19:49:35'!
= aPosition

	^ position = aPosition.! !

!MarsRoverPosition methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 21:11:45'!
initializeWith: aPosition

	position := aPosition.! !

!MarsRoverPosition methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 19:44:23'!
position

	^ position! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverPosition class' category: 'MarsRover-WithHeading'!
MarsRoverPosition class
	instanceVariableNames: ''!

!MarsRoverPosition class methodsFor: 'as yet unclassified' stamp: 'BK 10/29/2023 19:19:26'!
at: aPosition

	^ self new initializeWith: aPosition.! !
