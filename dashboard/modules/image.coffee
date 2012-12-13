define ['cs!widget'], (Widget) ->
    
    class ImageWidget extends Widget

        template_name: 'templates/image.hjs'
        
        subscribed_channels: ['/image']
        
        events:
            "click a.save-image": "saveImageToFile"
        
        initialize: =>
            ###
                Create an HTML5 canvas which will be used
                to render the image.
            ###
            @renderLayout()

            # Normally we would use "elements" for this, but we want the
            # raw DOM element instead of the jQuery one.
            @canvas = @view.$el.find('canvas').get(0)
        
        get_image: (params) =>
            ###
                This gets called whenever there is a change
                in the image that has to be displayed.
            ###
            
            return unless params.type == 'change'
            
            # Create a 640 x 480 buffer
            context_2d = @canvas.getContext('2d')
            pixels = context_2d.createImageData(640, 480)
            
            # Get the base64-decoded image
            image = params.model.get('image')
            decoded_image = atob(image)
            
            # Transfer pixels from the decoded image to canvas
            # buffer. NOTE: canvas also has an alpha channel.
            for x in [0..639]
                for y in [0..479]
                    index = (y * 640 + x) * 4
                    index2 = (y * 640 + x) * 3
                    pixels.data[index] = decoded_image[index2].charCodeAt(0)
                    pixels.data[index + 1] = decoded_image[index2 + 1].charCodeAt(0)
                    pixels.data[index + 2] = decoded_image[index2 + 2].charCodeAt(0)
                    pixels.data[index + 3] = 255
            
            # Render the actual image to HTML
            context_2d.putImageData(pixels, 0, 0)

        saveImageToFile: (event) =>
            urlData = @canvas.toDataURL('image/jpeg')
            window.open(urlData, 'Save image to file')