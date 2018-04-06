#!flask/bin/python
from flask import Flask, jsonify
from flask import abort
import array
from flask import request
from flask import make_response
from flask import url_for


app = Flask(__name__)


	  
services = [
    {
        'id': 1,
		'uniqueID' : u'0.0.1.1.epochtime',
        'service': u'test',
        'version': u'0.0.1', 
        'change': u'created'
    },
    {
        'id': 2,
		'uniqueID' : u'0.0.1.2.epochtime',
        'service': u'test',
	    'version': u'0.0.1', 
        'change': u'created'
    },
	{
        'id': 3,
		'uniqueID' : u'0.0.2.1.epochtime',
        'service': u'test',
        'version': u'0.0.2', 
        'change': u'created'
    },
    {
        'id': 4,
		'uniqueID' : u'0.0.2.2.epochtime',
        'service': u'test',
	    'version': u'0.0.2', 
        'change': u'created'
    },
    {
        'id': 5,
		'uniqueID' : u'0.0.2.1.epochtime',
        'service': u'test2',
	    'version': u'0.0.2', 
        'change': u'created'
    },
	    {
        'id': 6,
		'uniqueID' : u'0.0.2.2.epochtime',
        'service': u'test2',
	    'version': u'0.0.2', 
        'change': u'created'
    }
]

@app.route('/service_registry/api/v1.0/services', methods=['GET'])
def get_services():
#    return jsonify({'services': services})
     return jsonify({'services': [make_public_service(service) for service in services]})

@app.route('/service_registry/api/v1.0/services/<int:service_id>', methods=['GET'])
def get_service_id(service_id):
    service = [service for service in services if service['id'] == service_id]
    if len(service) == 0:
        abort(404)
    return jsonify({'service': service[0]})
	
@app.route('/service_registry/api/v1.0/services/<service_name_all>/getAll', methods=['GET'])
def get_service_all(service_name_all):
    service = [service for service in services if service['service'] == service_name_all]
    if len(service) == 0:
        abort(404)
    return jsonify({'service': service})
	




@app.route('/service_registry/api/v1.0/services/<service_name>', methods=['GET'])
def get_service(service_name):
    service = [service for service in services if service['service'] == service_name]
    if len(service) == 0:
            return jsonify({'service': service_name,'count': 0 })
    count=len(service)	
    return jsonify({'service': service_name,'count': count })
@app.route('/service_registry/api/v1.0/services/<service_name>/<service_version>', methods=['GET'])
def get_service_count(service_name,service_version):
    service = [service for service in services if service['service'] == service_name and service['version'] == service_version]
    if len(service) == 0:
            return jsonify({'service': service_name, 'version' : 'service_version', 'count': 0 })
    count=len(service)	
    #return jsonify({'service': service})	
    return jsonify({'service': service_name, 'version' : 'service_version', 'count': count })
	

#return a nice message if not found
@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

#@app.route('/service_registry/api/v1.0/services/<service_name>/<service_version>', methods=['POST'])
@app.route('/service_registry/api/v1.0/services', methods=['POST'])
def create_service():
    if not request.json or not 'service' in request.json or not 'version' in request.json:
        abort(400)
    service = {
        'id': services[-1]['id'] + 1,
        'service': request.json['service'],
        'version': request.json.get('version', ""),
#        'uniqueID' : u'0.0.2.2.epochtime',
        'change': u'created'
    }

    


@app.route('/service_registry/api/v1.0/services/<int:service_id>', methods=['PUT'])
def update_service(service_id):
    service = [service for service in services if service['id'] == service_id]
    if len(service) == 0:
        abort(404)
    if not request.json:
        abort(400)
    if 'title' in request.json and type(request.json['version']) != unicode:
        abort(400)
    if 'description' in request.json and type(request.json['version']) is not unicode:
        abort(400)
    if 'done' in request.json and type(request.json['change']) is not unicode:
        abort(400)
    service[0]['version'] = request.json.get('service', service[0]['service'])
    service[0]['version'] = request.json.get('version', service[0]['version'])
    service[0]['change'] = 'changed'
#    service[0]['change_version'] = request.json.get('done', service[0]['done']))
    return jsonify({'service': service[0]})

@app.route('/service_registry/api/v1.0/services/<int:service_id>', methods=['DELETE'])
def delete_service(service_id):
    service = [service for service in services if service['id'] == service_id]
    if len(service) == 0:
        abort(404)
    services.remove(service[0])
    return jsonify({'change': 'removed'})
    services.append(service)
    return jsonify({'service': service}), 201

def make_public_service(service):
    new_service = {}
    for field in service:
        if field == 'id':
            new_service['uri'] = url_for('get_services', service_id=service['id'], _external=True)
        else:
            new_service[field] = service[field]
    return new_service

if __name__ == '__main__':
    app.run(debug=True)
