select transform([1, 2, 3], a INT -> a * 2);

select transform([
    {'label':'a', 'value':1},
    {'label':'b', 'value':2},
    {'label':'c', 'value':3}
], a -> {'label':a:label, 'value':a:value * 2});

select transform([
    {'label':'a', 'value':1},
    {'label':'b', 'value':2},
    {'label':'c', 'value':3}
], a -> object_insert(a, 'new', {'value2':a:value * 2}));

select transform(
    filter([
        {'label':'a', 'value':1},
        {'label':'b', 'value':2},
        {'label':'c', 'value':3}
    ], a -> a:value >=2),
    a -> object_insert(a, 'new', {'value2':a:value * 2}));
