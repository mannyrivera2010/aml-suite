from collections import OrderedDict


def shorthand_types(input_object):
    """
    {'title':'app1', 'category':[{'title':'weather'},{'title':'utils'}]}
        TO
    {
     'type':'dict',
     'props':{
        'title':{
            'type': 'string'
        },
        'category':{
            'type': 'list'
            'items':[
                {'type': 'dict'
                 'props':{
                    'title':{'type':'string'}
                 }
                }
            ]
        }
     }
    }
    """
    # is_base_boolean = isinstance(input_object, (int, str, float))
    is_dict_boolean = isinstance(input_object, dict)
    is_list_boolean = isinstance(input_object, list)

    if is_list_boolean:
        dict_set = set()
        interm = []
        for item in input_object:
            # item_value = shorthand_types(item)
            #
            # if str(item_value) not in dict_set:
            #     interm.append(item_value)
            # dict_set.add(str(item_value))

            interm.append(shorthand_types(item))

        output_dict = OrderedDict({'type': 'list', 'items': [], 'len': len(input_object)})

        for item in interm:
            output_dict['items'].append(item)

        return output_dict
    elif is_dict_boolean:
        sorted_keys = sorted(input_object.keys())
        output_dict = OrderedDict({'type': 'dict', 'props': OrderedDict({})})

        for key in sorted_keys:
            output_dict['props'][key] = shorthand_types(input_object[key])

        return output_dict
    else:
        return OrderedDict({'type': input_object.__class__.__name__})


def shorthand_dict(input_object, key='', prefix_key='', exclude_keys=[]):
    """
    Recursive function to create a shorthand representation of complex python objects into a string

    Example for dictionary:
        {'title':'app1', 'category':[{'title':'weather'},{'title':'utils'}]}
            TO
        (category:[(title:weather),(title:utils)],title:app1)

    Example for list of complex objects:
        [
            {'title':'app1', 'category':[{'title':'weather'},{'title':'utils'}]},
            {'title':'app1', 'category':[{'title':'weather'},{'title':'utils'}]}
        ]
        TO
        [
            '(category:[(title:weather),(title:utils)],title:app1)',
            '(category:[(title:weather),(title:utils)],title:app1)'
        ]

        TODO: Get {'data':[1,[2,[3]]]}) to work
    Usage:
        shorthand_dict({'key1':'app1', 'category':[{'key2':'weather'},{'key3':'utils'}]})
    """
    is_base_boolean = isinstance(input_object, (int, str, float))
    is_dict_boolean = isinstance(input_object, dict)
    is_list_boolean = isinstance(input_object, list)
    has_key = True if key else False
    if is_list_boolean and not has_key and not prefix_key:
        return [shorthand_dict(ob, exclude_keys=exclude_keys) for ob in input_object]
    elif is_list_boolean and not has_key and prefix_key:
        output = []
        for index, ob in enumerate(input_object, start=0):
            current_prefix_key = '{}[{}]'.format(prefix_key, index) if prefix_key else '{}[{}]'.format(prefix_key, index)
            if current_prefix_key not in exclude_keys:
                output.append(shorthand_dict(ob, prefix_key=current_prefix_key, exclude_keys=exclude_keys))
        return '[{}]'.format(','.join(output))
    elif is_list_boolean and has_key:
        output = []
        for index, ob in enumerate(input_object, start=0):
            current_prefix_key = '{}[{}]'.format(key, index) if prefix_key else '{}[{}]'.format(key, index)
            if current_prefix_key not in exclude_keys:
                output.append(shorthand_dict(ob, prefix_key=current_prefix_key, exclude_keys=exclude_keys))
        return '[{}]'.format(','.join(output))
    elif is_dict_boolean:
        sorted_keys = sorted(input_object.keys())
        output = []
        for key in sorted_keys:
            current_prefix_key = '{}.{}'.format(prefix_key, key) if prefix_key else '{}'.format(key)
            if current_prefix_key not in exclude_keys:
                output.append('{}:{}'.format(key, shorthand_dict(input_object[key], key, prefix_key=current_prefix_key, exclude_keys=exclude_keys)))
        return '({})'.format(','.join(output))
    elif is_base_boolean:
        # print('{}={}'.format(prefix_key, input_object))  # Debug key location
        return '{}'.format(input_object)
