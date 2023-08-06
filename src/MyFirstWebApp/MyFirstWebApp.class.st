"
This is my first pharo web app
"
Class {
	#name : #MyFirstWebApp,
	#superclass : #Object,
	#instVars : [
		'image'
	],
	#category : #MyFirstWebApp
}

{ #category : #accessing }
MyFirstWebApp >> downloadPharoLogo [

	^ ZnClient new
		  beOneShot;
		  get: 'http://pharo.org/files/pharo.png';
		  entity
]

{ #category : #accessing }
MyFirstWebApp >> form [

	^ self formForImageEntity: self image
]

{ #category : #accessing }
MyFirstWebApp >> formForImageEntity: imageEntity [

	| imageType parserClass parser parsers |
	parsers := Dictionary new
		           add: #jpg -> JPEGReadWriter;
		           add: #jpeg -> JPEGReadWriter;
		           add: #png -> PNGReadWriter;
		           add: #gif -> GIFReadWriter;
		           yourself.
	imageType := imageEntity contentType sub.
	parserClass := parsers at: imageType asSymbol.
	parser := parserClass on: imageEntity readStream.
	^ parser nextImage
]

{ #category : #'request handling' }
MyFirstWebApp >> handleGetRequest: request [

	^ (request uri queryAt: #raw ifAbsent: [ nil ])
		  ifNil: [ ZnResponse ok: (ZnEntity html: self html) ]
		  ifNotNil: [ ZnResponse ok: self image ]
]

{ #category : #'request handling' }
MyFirstWebApp >> handlePostRequest: request [

	| part newImage badRequest |
	badRequest := [ ^ ZnResponse badRequest: request ].
	(request hasEntity and: [
		 request contentType matches: ZnMimeType multiPartFormData ])
		ifFalse: badRequest.
	part := request entity partNamed: #file ifNone: badRequest.
	newImage := part entity.
	(newImage notNil and: [
		 newImage contentType matches: 'image/*' asZnMimeType ]) ifFalse:
		badRequest.
	[ self formForImageEntity: newImage ]
		on: Error
		do: badRequest.
	self image: newImage.
	^ ZnResponse redirect: #image
]

{ #category : #public }
MyFirstWebApp >> handleRequest: request [

	request uri path = #image ifTrue: [
		request method = #GET ifTrue: [ ^ self handleGetRequest: request ].
		request method = #POST ifTrue: [ ^ self handlePostRequest: request ] ].
	^ ZnResponse notFound: request uri
]

{ #category : #'response transformers' }
MyFirstWebApp >> html [

	^ '<html><head><title>Image</title>
	<body>
	<h1>Image</h1>
	<img src="image?raw=true"/>
	<br />
	<form enctype="multipart/form-data" action="image" method="POST">
		<h3>Change the image:</h3>
		<input type="file" name="file"/>
		<input type="submit" value="Upload"/>
	</form>
	</body></html>'
]

{ #category : #accessing }
MyFirstWebApp >> image [

	^ image ifNil: [ image := self downloadPharoLogo ]
]

{ #category : #accessing }
MyFirstWebApp >> image: anObject [

	image := anObject
]

{ #category : #accessing }
MyFirstWebApp >> value: request [

	^ self handleRequest: request
]
