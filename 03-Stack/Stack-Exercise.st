!classDefinition: #OOStackTest category: 'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:29:55'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:01'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:09'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'NR 9/16/2021 17:40:17'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'firstSomething'.
	secondPushedObject := 'secondSomething'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:20'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:24'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'fa 9/18/2023 17:33:50'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'NR 5/13/2020 13:30:31'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #SentenceFinderByPrefixTest category: 'Stack-Exercise'!
TestCase subclass: #SentenceFinderByPrefixTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'fa 9/18/2023 16:20:34'!
createStackFrom: testStringCollection
	| stack |
	stack := OOStack new.
	testStringCollection do: [ :string | stack push: string].
	^stack.
	! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'fa 9/18/2023 16:41:21'!
runSentenceFinderOn: testStringCollection withPrefix: prefix andAssertEquals: expectedCollection
	|orderedCollection|
	orderedCollection := OrderedCollection new.
	orderedCollection addAll: expectedCollection.
	self assert: (
		SentenceFinderByPrefix 
			findAllSentencesWithPrefix:  prefix
			in: (self createStackFrom: testStringCollection)
		) = orderedCollection.! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'fa 9/18/2023 16:16:00'!
test01ReturnEmptyCollectionOnEmptyStack
	self  	
		runSentenceFinderOn: #()
		withPrefix: 'hola' 
		andAssertEquals: #().! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'fa 9/18/2023 17:13:58'!
test02ReturnsCorrectPrefixCollection
	self
		runSentenceFinderOn: #('queso brie' 'abrir' 'brindar soporte' 'brillo' 'britain')
		withPrefix: 'bri'
		andAssertEquals: #('britain' 'brillo' 'brindar soporte').! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'fa 9/18/2023 16:17:50'!
test03CorrectlySkipsCaseMismatches
	self
		runSentenceFinderOn: #('queso brie', 'abrir', 'Brindar soporte', 'Brillo', 'Britain')
		withPrefix: 'bri'
		andAssertEquals: #().! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'fa 9/18/2023 17:33:12'!
test04CorrectlySkipsSpaceMismatches
	self
		runSentenceFinderOn: #(' queso brie', ' abrir', 'brindar soporte', ' brillo', ' britain')
		withPrefix: 'bri'
		andAssertEquals: #('brindar soporte').! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'fa 9/18/2023 17:33:35'!
test05DoesNotModifyStack
	|stack testCollection index|
	testCollection := #('queso brie', 'abrir', 'brindar soporte', 'brillo', 'britain').
	stack := self createStackFrom:  testCollection.
	
	SentenceFinderByPrefix 
		findAllSentencesWithPrefix:  'bri' 
		in: stack.
		
	index := testCollection size.
	[stack isEmpty] whileFalse: [
		self assert: stack pop = (testCollection at: index).
		index := index - 1.
	].

	
	! !

!SentenceFinderByPrefixTest methodsFor: 'test' stamp: 'fa 9/18/2023 17:36:31'!
test06CanNotUseSentenceFinderWithEmptyPrefix
	self
		should: [
			SentenceFinderByPrefix 
				findAllSentencesWithPrefix:  ''
				in: (self createStackFrom: #('shouldFail')) 
		]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = SentenceFinderByPrefix prefixIsEmptyErrorDescription ]
		! !


!classDefinition: #OOAbstractStack category: 'Stack-Exercise'!
Object subclass: #OOAbstractStack
	instanceVariableNames: 'stack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOAbstractStack class' category: 'Stack-Exercise'!
OOAbstractStack class
	instanceVariableNames: ''!

!OOAbstractStack class methodsFor: 'error descriptions' stamp: 'fa 9/18/2023 08:49:54'!
stackEmptyErrorDescription
	
	^ 'stack is empty!!!!!!'! !


!classDefinition: #OOStack category: 'Stack-Exercise'!
OOAbstractStack subclass: #OOStack
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'state modifiers' stamp: 'fa 9/18/2023 15:20:06'!
pop
	|headElement|
	headElement := stack top.
	stack := stack tail.
	^headElement.! !

!OOStack methodsFor: 'state modifiers' stamp: 'fa 9/18/2023 08:54:36'!
push: newElement
	stack := stack push: newElement.! !


!OOStack methodsFor: 'initialization' stamp: 'fa 9/18/2023 08:37:48'!
initialize
	super initialize.
	stack := OOStackEmpty new.! !


!OOStack methodsFor: 'observers' stamp: 'fa 9/18/2023 08:26:09'!
isEmpty
	^stack isEmpty.! !

!OOStack methodsFor: 'observers' stamp: 'fa 9/18/2023 15:32:36'!
size
	^stack size.! !

!OOStack methodsFor: 'observers' stamp: 'fa 9/18/2023 15:32:29'!
top
	^stack top.! !


!classDefinition: #OOStackEmpty category: 'Stack-Exercise'!
OOAbstractStack subclass: #OOStackEmpty
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackEmpty methodsFor: 'observers' stamp: 'fa 9/18/2023 08:40:12'!
isEmpty
	^true.! !

!OOStackEmpty methodsFor: 'observers' stamp: 'fa 9/18/2023 08:40:25'!
size
	^0.! !

!OOStackEmpty methodsFor: 'observers' stamp: 'fa 9/18/2023 15:19:07'!
top
	^self error: self class stackEmptyErrorDescription.! !


!OOStackEmpty methodsFor: 'state modifiers' stamp: 'fa 9/18/2023 08:55:09'!
pop
	^self error: self class stackEmptyErrorDescription.! !

!OOStackEmpty methodsFor: 'state modifiers' stamp: 'fa 9/18/2023 15:22:46'!
push: newElement
	^OOStackNonEmpty withHead: newElement andTail: self.! !


!classDefinition: #OOStackNonEmpty category: 'Stack-Exercise'!
OOAbstractStack subclass: #OOStackNonEmpty
	instanceVariableNames: 'tail head'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackNonEmpty methodsFor: 'state modifiers' stamp: 'fa 9/18/2023 15:19:22'!
push: newElement
	tail := self copy.
	head := newElement.
	^self.! !

!OOStackNonEmpty methodsFor: 'state modifiers' stamp: 'fa 9/18/2023 15:29:09'!
setHead: headElement andTail: tailStack
	head := headElement.
	tail := tailStack.! !

!OOStackNonEmpty methodsFor: 'state modifiers' stamp: 'fa 9/18/2023 15:18:34'!
top
	^head.! !


!OOStackNonEmpty methodsFor: 'observers' stamp: 'fa 9/17/2023 19:48:28'!
isEmpty
	^false.! !

!OOStackNonEmpty methodsFor: 'observers' stamp: 'fa 9/18/2023 08:57:47'!
size
	^1 + tail size.! !

!OOStackNonEmpty methodsFor: 'observers' stamp: 'fa 9/18/2023 15:18:05'!
tail
	^tail.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStackNonEmpty class' category: 'Stack-Exercise'!
OOStackNonEmpty class
	instanceVariableNames: ''!

!OOStackNonEmpty class methodsFor: 'as yet unclassified' stamp: 'fa 9/18/2023 15:28:34'!
withHead: headElement andTail: tailStack
	
	|newOOStackNonEmpty|
	newOOStackNonEmpty := OOStackNonEmpty new.
	newOOStackNonEmpty setHead: headElement andTail: tailStack.
	^newOOStackNonEmpty.! !


!classDefinition: #SentenceFinderByPrefix category: 'Stack-Exercise'!
Object subclass: #SentenceFinderByPrefix
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SentenceFinderByPrefix class' category: 'Stack-Exercise'!
SentenceFinderByPrefix class
	instanceVariableNames: ''!

!SentenceFinderByPrefix class methodsFor: 'error descriptions' stamp: 'fa 9/18/2023 17:21:27'!
prefixIsEmptyErrorDescription
	^'prefix should not be an empty string'.

! !


!SentenceFinderByPrefix class methodsFor: 'find' stamp: 'fa 9/18/2023 17:38:33'!
findAllSentencesWithPrefix: aPrefixString in: aStack	
	|temporalStack foundSentencesCollection|
	aPrefixString isEmpty ifTrue: [^self error: self prefixIsEmptyErrorDescription ].
	
	temporalStack := OOStack new. 
	foundSentencesCollection := OrderedCollection new.
	[aStack isEmpty] whileFalse: [
		|substring stackHead|
		stackHead := aStack pop.
		temporalStack push: stackHead.
		substring := stackHead copyFrom: 1 to: ((aPrefixString size) min: (stackHead size)).
		(aPrefixString = substring) ifTrue: [
			foundSentencesCollection add: stackHead.
		].
	].
	[temporalStack isEmpty] whileFalse: [
		aStack push: (temporalStack pop).	
	].

	^foundSentencesCollection.! !
