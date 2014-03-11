class ColladaView extends JSGLView
    constructor:(frame, bgColor, alpha, antialias)->
        super(frame, bgColor, alpha, antialias)
        ###
        Please describe initialization processing of a class below from here. 
        ###

    viewDidAppear:->
        super()
        ###
        Please describe the processing about a view below from here. 
        ###
        if (@fname?)
            @dispModel(@fname)

    dispModel:->
        documentpath = JSSearchPathForDirectoriesInDomains("JSDocumentDirectory")
        mediapath = documentpath+"/../../media"
        loader = new THREE.ColladaLoader()
        loader.load mediapath+"/"+@fname, (collada)=>
            @model = collada.scene
            @model.scale.set(1.0, 1.0, 1.0)
            @_scene.add(@model)
            @render()

    enterFrame:->
        @model.rotation.y = 0.2 * (+new Date - @_baseTime) / 1000;
        @model.rotation.x = 0.2 * (+new Date - @_baseTime) / 1000;
        @model.rotation.z = 0.2 * (+new Date - @_baseTime) / 1000;
