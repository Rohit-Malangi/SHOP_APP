import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/products_provider.dart';
import '../provider/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _discriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editProduct =
      Product(id: null, description: '', price: 0, imageUrl: '', title: '');
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _imageUrlController.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _discriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error Occurs!'),
            content: const Text('Someting Went Wrong!'),
            actions: [
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // } finally {
      //   Navigator.of(context).pop();
      //   _isLoading = false;
      // }
      /*setState(() {
        _isLoading = false;
      });*/
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productid = ModalRoute.of(context).settings.arguments as String;
      if (productid != null) {
        _editProduct =
            Provider.of<ProductsProvider>(context).findById(productid);
        _initvalues = {
          'title': _editProduct.title,
          'price': _editProduct.price.toString(),
          'discription': _editProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  var _initvalues = {
    'title': '',
    'price': '',
    'discription': '',
    'imageUrl': '',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: Icon(Icons.done)),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initvalues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          title: value,
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                          description: _editProduct.description,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'Please Enter a Title';
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initvalues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_discriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                          title: _editProduct.title,
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                          description: _editProduct.description,
                          price: double.parse(value),
                          imageUrl: _editProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'Please Enter a Price';
                        if (double.tryParse(value) == null)
                          return 'Please Enter a Valid Number';
                        if (double.parse(value) <= 0)
                          return 'Please Enter a Positive Number';
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initvalues['discription'],
                      decoration: InputDecoration(labelText: 'Discription'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _discriptionFocusNode,
                      onSaved: (value) {
                        _editProduct = Product(
                          title: _editProduct.title,
                          id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                          description: value,
                          price: _editProduct.price,
                          imageUrl: _editProduct.imageUrl,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) return 'Please Enter a Discription';
                        if (value.length < 10)
                          return 'Please Enter at least 10 character in discription';
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: Theme.of(context).primaryColor),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Add Image',
                                  textAlign: TextAlign.center)
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editProduct = Product(
                                title: _editProduct.title,
                                id: _editProduct.id,
                                isFavorite: _editProduct.isFavorite,
                                description: _editProduct.description,
                                price: _editProduct.price,
                                imageUrl: value,
                              );
                            },
                            validator: (value) {
                              if (value.isEmpty)
                                return 'Please Enter a Image URL or Correct Image URL';
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https'))
                                return 'Please enter a valid URL';
                              return null;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
