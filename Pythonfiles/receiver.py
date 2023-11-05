from flask import Flask, request

app = Flask(__name__)

@app.route('/upload', methods=['POST'])
def upload_image():
    if 'image' in request.files:
        image = request.files['image']
        # Save the image to a location on your server
        image.save('path_to_save_image.jpg')
        return 'Image uploaded successfully'
    else:
        return 'No image provided in the request', 400

if __name__ == '__main__':
    app.run(host='192.168.0.148', port=8080, debug=True)
