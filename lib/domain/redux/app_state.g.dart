// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppState extends AppState {
  @override
  final User user;
  @override
  final int userId;
  @override
  final Business currentActiveBusiness;
  @override
  final int tab;
  @override
  final Business nextActiveBusiness;
  @override
  final Sheets sheet;
  @override
  final AppActions action;
  @override
  final Price price;
  @override
  final String businessId;
  @override
  final Unit unit;
  @override
  final Unit customUnit;
  @override
  final Item customItem;
  @override
  final Category customCategory;
  @override
  final BuiltList<Unit> units;
  @override
  final BuiltList<User> users;
  @override
  final int focusedUnit;
  @override
  final Category category;
  @override
  final Permission permissions;
  @override
  final List<Branch> branches;
  @override
  final List<Business> businesses;
  @override
  final Branch branch;
  @override
  final Business business;
  @override
  final Hint hint;
  @override
  final Database database;
  @override
  final CouchBase couch;
  @override
  final int tempCategoryId;
  @override
  final Unit currentUnit;
  @override
  final FlipperColor currentColor;
  @override
  final BuiltList<Item> itemVariations;
  @override
  final Item currentActiveSaleItem;
  @override
  final Item cartItem;
  @override
  final BuiltList<Item> items;
  @override
  final int currentIncrement;
  @override
  final BuiltList<Cart> carts;
  @override
  final int cartQuantities;
  @override
  final Order order;
  @override
  final KeyPad keypad;
  @override
  final Item tmpItem;
  @override
  final CouchDbClient couchDbClient;

  factory _$AppState([void Function(AppStateBuilder) updates]) =>
      (new AppStateBuilder()..update(updates)).build();

  _$AppState._(
      {this.user,
      this.userId,
      this.currentActiveBusiness,
      this.tab,
      this.nextActiveBusiness,
      this.sheet,
      this.action,
      this.price,
      this.businessId,
      this.unit,
      this.customUnit,
      this.customItem,
      this.customCategory,
      this.units,
      this.users,
      this.focusedUnit,
      this.category,
      this.permissions,
      this.branches,
      this.businesses,
      this.branch,
      this.business,
      this.hint,
      this.database,
      this.couch,
      this.tempCategoryId,
      this.currentUnit,
      this.currentColor,
      this.itemVariations,
      this.currentActiveSaleItem,
      this.cartItem,
      this.items,
      this.currentIncrement,
      this.carts,
      this.cartQuantities,
      this.order,
      this.keypad,
      this.tmpItem,
      this.couchDbClient})
      : super._() {
    if (database == null) {
      throw new BuiltValueNullFieldError('AppState', 'database');
    }
    if (couch == null) {
      throw new BuiltValueNullFieldError('AppState', 'couch');
    }
    if (itemVariations == null) {
      throw new BuiltValueNullFieldError('AppState', 'itemVariations');
    }
    if (items == null) {
      throw new BuiltValueNullFieldError('AppState', 'items');
    }
    if (carts == null) {
      throw new BuiltValueNullFieldError('AppState', 'carts');
    }
  }

  @override
  AppState rebuild(void Function(AppStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        user == other.user &&
        userId == other.userId &&
        currentActiveBusiness == other.currentActiveBusiness &&
        tab == other.tab &&
        nextActiveBusiness == other.nextActiveBusiness &&
        sheet == other.sheet &&
        action == other.action &&
        price == other.price &&
        businessId == other.businessId &&
        unit == other.unit &&
        customUnit == other.customUnit &&
        customItem == other.customItem &&
        customCategory == other.customCategory &&
        units == other.units &&
        users == other.users &&
        focusedUnit == other.focusedUnit &&
        category == other.category &&
        permissions == other.permissions &&
        branches == other.branches &&
        businesses == other.businesses &&
        branch == other.branch &&
        business == other.business &&
        hint == other.hint &&
        database == other.database &&
        couch == other.couch &&
        tempCategoryId == other.tempCategoryId &&
        currentUnit == other.currentUnit &&
        currentColor == other.currentColor &&
        itemVariations == other.itemVariations &&
        currentActiveSaleItem == other.currentActiveSaleItem &&
        cartItem == other.cartItem &&
        items == other.items &&
        currentIncrement == other.currentIncrement &&
        carts == other.carts &&
        cartQuantities == other.cartQuantities &&
        order == other.order &&
        keypad == other.keypad &&
        tmpItem == other.tmpItem &&
        couchDbClient == other.couchDbClient;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            $jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc(0, user.hashCode), userId.hashCode), currentActiveBusiness.hashCode), tab.hashCode), nextActiveBusiness.hashCode), sheet.hashCode), action.hashCode), price.hashCode), businessId.hashCode), unit.hashCode), customUnit.hashCode), customItem.hashCode), customCategory.hashCode), units.hashCode), users.hashCode), focusedUnit.hashCode), category.hashCode), permissions.hashCode), branches.hashCode), businesses.hashCode),
                                                                                branch.hashCode),
                                                                            business.hashCode),
                                                                        hint.hashCode),
                                                                    database.hashCode),
                                                                couch.hashCode),
                                                            tempCategoryId.hashCode),
                                                        currentUnit.hashCode),
                                                    currentColor.hashCode),
                                                itemVariations.hashCode),
                                            currentActiveSaleItem.hashCode),
                                        cartItem.hashCode),
                                    items.hashCode),
                                currentIncrement.hashCode),
                            carts.hashCode),
                        cartQuantities.hashCode),
                    order.hashCode),
                keypad.hashCode),
            tmpItem.hashCode),
        couchDbClient.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppState')
          ..add('user', user)
          ..add('userId', userId)
          ..add('currentActiveBusiness', currentActiveBusiness)
          ..add('tab', tab)
          ..add('nextActiveBusiness', nextActiveBusiness)
          ..add('sheet', sheet)
          ..add('action', action)
          ..add('price', price)
          ..add('businessId', businessId)
          ..add('unit', unit)
          ..add('customUnit', customUnit)
          ..add('customItem', customItem)
          ..add('customCategory', customCategory)
          ..add('units', units)
          ..add('users', users)
          ..add('focusedUnit', focusedUnit)
          ..add('category', category)
          ..add('permissions', permissions)
          ..add('branches', branches)
          ..add('businesses', businesses)
          ..add('branch', branch)
          ..add('business', business)
          ..add('hint', hint)
          ..add('database', database)
          ..add('couch', couch)
          ..add('tempCategoryId', tempCategoryId)
          ..add('currentUnit', currentUnit)
          ..add('currentColor', currentColor)
          ..add('itemVariations', itemVariations)
          ..add('currentActiveSaleItem', currentActiveSaleItem)
          ..add('cartItem', cartItem)
          ..add('items', items)
          ..add('currentIncrement', currentIncrement)
          ..add('carts', carts)
          ..add('cartQuantities', cartQuantities)
          ..add('order', order)
          ..add('keypad', keypad)
          ..add('tmpItem', tmpItem)
          ..add('couchDbClient', couchDbClient))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState _$v;

  UserBuilder _user;
  UserBuilder get user => _$this._user ??= new UserBuilder();
  set user(UserBuilder user) => _$this._user = user;

  int _userId;
  int get userId => _$this._userId;
  set userId(int userId) => _$this._userId = userId;

  BusinessBuilder _currentActiveBusiness;
  BusinessBuilder get currentActiveBusiness =>
      _$this._currentActiveBusiness ??= new BusinessBuilder();
  set currentActiveBusiness(BusinessBuilder currentActiveBusiness) =>
      _$this._currentActiveBusiness = currentActiveBusiness;

  int _tab;
  int get tab => _$this._tab;
  set tab(int tab) => _$this._tab = tab;

  BusinessBuilder _nextActiveBusiness;
  BusinessBuilder get nextActiveBusiness =>
      _$this._nextActiveBusiness ??= new BusinessBuilder();
  set nextActiveBusiness(BusinessBuilder nextActiveBusiness) =>
      _$this._nextActiveBusiness = nextActiveBusiness;

  SheetsBuilder _sheet;
  SheetsBuilder get sheet => _$this._sheet ??= new SheetsBuilder();
  set sheet(SheetsBuilder sheet) => _$this._sheet = sheet;

  AppActionsBuilder _action;
  AppActionsBuilder get action => _$this._action ??= new AppActionsBuilder();
  set action(AppActionsBuilder action) => _$this._action = action;

  PriceBuilder _price;
  PriceBuilder get price => _$this._price ??= new PriceBuilder();
  set price(PriceBuilder price) => _$this._price = price;

  String _businessId;
  String get businessId => _$this._businessId;
  set businessId(String businessId) => _$this._businessId = businessId;

  UnitBuilder _unit;
  UnitBuilder get unit => _$this._unit ??= new UnitBuilder();
  set unit(UnitBuilder unit) => _$this._unit = unit;

  UnitBuilder _customUnit;
  UnitBuilder get customUnit => _$this._customUnit ??= new UnitBuilder();
  set customUnit(UnitBuilder customUnit) => _$this._customUnit = customUnit;

  ItemBuilder _customItem;
  ItemBuilder get customItem => _$this._customItem ??= new ItemBuilder();
  set customItem(ItemBuilder customItem) => _$this._customItem = customItem;

  CategoryBuilder _customCategory;
  CategoryBuilder get customCategory =>
      _$this._customCategory ??= new CategoryBuilder();
  set customCategory(CategoryBuilder customCategory) =>
      _$this._customCategory = customCategory;

  ListBuilder<Unit> _units;
  ListBuilder<Unit> get units => _$this._units ??= new ListBuilder<Unit>();
  set units(ListBuilder<Unit> units) => _$this._units = units;

  ListBuilder<User> _users;
  ListBuilder<User> get users => _$this._users ??= new ListBuilder<User>();
  set users(ListBuilder<User> users) => _$this._users = users;

  int _focusedUnit;
  int get focusedUnit => _$this._focusedUnit;
  set focusedUnit(int focusedUnit) => _$this._focusedUnit = focusedUnit;

  CategoryBuilder _category;
  CategoryBuilder get category => _$this._category ??= new CategoryBuilder();
  set category(CategoryBuilder category) => _$this._category = category;

  PermissionBuilder _permissions;
  PermissionBuilder get permissions =>
      _$this._permissions ??= new PermissionBuilder();
  set permissions(PermissionBuilder permissions) =>
      _$this._permissions = permissions;

  List<Branch> _branches;
  List<Branch> get branches => _$this._branches;
  set branches(List<Branch> branches) => _$this._branches = branches;

  List<Business> _businesses;
  List<Business> get businesses => _$this._businesses;
  set businesses(List<Business> businesses) => _$this._businesses = businesses;

  BranchBuilder _branch;
  BranchBuilder get branch => _$this._branch ??= new BranchBuilder();
  set branch(BranchBuilder branch) => _$this._branch = branch;

  BusinessBuilder _business;
  BusinessBuilder get business => _$this._business ??= new BusinessBuilder();
  set business(BusinessBuilder business) => _$this._business = business;

  HintBuilder _hint;
  HintBuilder get hint => _$this._hint ??= new HintBuilder();
  set hint(HintBuilder hint) => _$this._hint = hint;

  Database _database;
  Database get database => _$this._database;
  set database(Database database) => _$this._database = database;

  CouchBase _couch;
  CouchBase get couch => _$this._couch;
  set couch(CouchBase couch) => _$this._couch = couch;

  int _tempCategoryId;
  int get tempCategoryId => _$this._tempCategoryId;
  set tempCategoryId(int tempCategoryId) =>
      _$this._tempCategoryId = tempCategoryId;

  UnitBuilder _currentUnit;
  UnitBuilder get currentUnit => _$this._currentUnit ??= new UnitBuilder();
  set currentUnit(UnitBuilder currentUnit) => _$this._currentUnit = currentUnit;

  FlipperColorBuilder _currentColor;
  FlipperColorBuilder get currentColor =>
      _$this._currentColor ??= new FlipperColorBuilder();
  set currentColor(FlipperColorBuilder currentColor) =>
      _$this._currentColor = currentColor;

  ListBuilder<Item> _itemVariations;
  ListBuilder<Item> get itemVariations =>
      _$this._itemVariations ??= new ListBuilder<Item>();
  set itemVariations(ListBuilder<Item> itemVariations) =>
      _$this._itemVariations = itemVariations;

  ItemBuilder _currentActiveSaleItem;
  ItemBuilder get currentActiveSaleItem =>
      _$this._currentActiveSaleItem ??= new ItemBuilder();
  set currentActiveSaleItem(ItemBuilder currentActiveSaleItem) =>
      _$this._currentActiveSaleItem = currentActiveSaleItem;

  ItemBuilder _cartItem;
  ItemBuilder get cartItem => _$this._cartItem ??= new ItemBuilder();
  set cartItem(ItemBuilder cartItem) => _$this._cartItem = cartItem;

  ListBuilder<Item> _items;
  ListBuilder<Item> get items => _$this._items ??= new ListBuilder<Item>();
  set items(ListBuilder<Item> items) => _$this._items = items;

  int _currentIncrement;
  int get currentIncrement => _$this._currentIncrement;
  set currentIncrement(int currentIncrement) =>
      _$this._currentIncrement = currentIncrement;

  ListBuilder<Cart> _carts;
  ListBuilder<Cart> get carts => _$this._carts ??= new ListBuilder<Cart>();
  set carts(ListBuilder<Cart> carts) => _$this._carts = carts;

  int _cartQuantities;
  int get cartQuantities => _$this._cartQuantities;
  set cartQuantities(int cartQuantities) =>
      _$this._cartQuantities = cartQuantities;

  OrderBuilder _order;
  OrderBuilder get order => _$this._order ??= new OrderBuilder();
  set order(OrderBuilder order) => _$this._order = order;

  KeyPadBuilder _keypad;
  KeyPadBuilder get keypad => _$this._keypad ??= new KeyPadBuilder();
  set keypad(KeyPadBuilder keypad) => _$this._keypad = keypad;

  ItemBuilder _tmpItem;
  ItemBuilder get tmpItem => _$this._tmpItem ??= new ItemBuilder();
  set tmpItem(ItemBuilder tmpItem) => _$this._tmpItem = tmpItem;

  CouchDbClientBuilder _couchDbClient;
  CouchDbClientBuilder get couchDbClient =>
      _$this._couchDbClient ??= new CouchDbClientBuilder();
  set couchDbClient(CouchDbClientBuilder couchDbClient) =>
      _$this._couchDbClient = couchDbClient;

  AppStateBuilder();

  AppStateBuilder get _$this {
    if (_$v != null) {
      _user = _$v.user?.toBuilder();
      _userId = _$v.userId;
      _currentActiveBusiness = _$v.currentActiveBusiness?.toBuilder();
      _tab = _$v.tab;
      _nextActiveBusiness = _$v.nextActiveBusiness?.toBuilder();
      _sheet = _$v.sheet?.toBuilder();
      _action = _$v.action?.toBuilder();
      _price = _$v.price?.toBuilder();
      _businessId = _$v.businessId;
      _unit = _$v.unit?.toBuilder();
      _customUnit = _$v.customUnit?.toBuilder();
      _customItem = _$v.customItem?.toBuilder();
      _customCategory = _$v.customCategory?.toBuilder();
      _units = _$v.units?.toBuilder();
      _users = _$v.users?.toBuilder();
      _focusedUnit = _$v.focusedUnit;
      _category = _$v.category?.toBuilder();
      _permissions = _$v.permissions?.toBuilder();
      _branches = _$v.branches;
      _businesses = _$v.businesses;
      _branch = _$v.branch?.toBuilder();
      _business = _$v.business?.toBuilder();
      _hint = _$v.hint?.toBuilder();
      _database = _$v.database;
      _couch = _$v.couch;
      _tempCategoryId = _$v.tempCategoryId;
      _currentUnit = _$v.currentUnit?.toBuilder();
      _currentColor = _$v.currentColor?.toBuilder();
      _itemVariations = _$v.itemVariations?.toBuilder();
      _currentActiveSaleItem = _$v.currentActiveSaleItem?.toBuilder();
      _cartItem = _$v.cartItem?.toBuilder();
      _items = _$v.items?.toBuilder();
      _currentIncrement = _$v.currentIncrement;
      _carts = _$v.carts?.toBuilder();
      _cartQuantities = _$v.cartQuantities;
      _order = _$v.order?.toBuilder();
      _keypad = _$v.keypad?.toBuilder();
      _tmpItem = _$v.tmpItem?.toBuilder();
      _couchDbClient = _$v.couchDbClient?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AppState;
  }

  @override
  void update(void Function(AppStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AppState build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          new _$AppState._(
              user: _user?.build(),
              userId: userId,
              currentActiveBusiness: _currentActiveBusiness?.build(),
              tab: tab,
              nextActiveBusiness: _nextActiveBusiness?.build(),
              sheet: _sheet?.build(),
              action: _action?.build(),
              price: _price?.build(),
              businessId: businessId,
              unit: _unit?.build(),
              customUnit: _customUnit?.build(),
              customItem: _customItem?.build(),
              customCategory: _customCategory?.build(),
              units: _units?.build(),
              users: _users?.build(),
              focusedUnit: focusedUnit,
              category: _category?.build(),
              permissions: _permissions?.build(),
              branches: branches,
              businesses: businesses,
              branch: _branch?.build(),
              business: _business?.build(),
              hint: _hint?.build(),
              database: database,
              couch: couch,
              tempCategoryId: tempCategoryId,
              currentUnit: _currentUnit?.build(),
              currentColor: _currentColor?.build(),
              itemVariations: itemVariations.build(),
              currentActiveSaleItem: _currentActiveSaleItem?.build(),
              cartItem: _cartItem?.build(),
              items: items.build(),
              currentIncrement: currentIncrement,
              carts: carts.build(),
              cartQuantities: cartQuantities,
              order: _order?.build(),
              keypad: _keypad?.build(),
              tmpItem: _tmpItem?.build(),
              couchDbClient: _couchDbClient?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();

        _$failedField = 'currentActiveBusiness';
        _currentActiveBusiness?.build();

        _$failedField = 'nextActiveBusiness';
        _nextActiveBusiness?.build();
        _$failedField = 'sheet';
        _sheet?.build();
        _$failedField = 'action';
        _action?.build();
        _$failedField = 'price';
        _price?.build();

        _$failedField = 'unit';
        _unit?.build();
        _$failedField = 'customUnit';
        _customUnit?.build();
        _$failedField = 'customItem';
        _customItem?.build();
        _$failedField = 'customCategory';
        _customCategory?.build();
        _$failedField = 'units';
        _units?.build();
        _$failedField = 'users';
        _users?.build();

        _$failedField = 'category';
        _category?.build();
        _$failedField = 'permissions';
        _permissions?.build();

        _$failedField = 'branch';
        _branch?.build();
        _$failedField = 'business';
        _business?.build();
        _$failedField = 'hint';
        _hint?.build();

        _$failedField = 'currentUnit';
        _currentUnit?.build();
        _$failedField = 'currentColor';
        _currentColor?.build();
        _$failedField = 'itemVariations';
        itemVariations.build();
        _$failedField = 'currentActiveSaleItem';
        _currentActiveSaleItem?.build();
        _$failedField = 'cartItem';
        _cartItem?.build();
        _$failedField = 'items';
        items.build();

        _$failedField = 'carts';
        carts.build();

        _$failedField = 'order';
        _order?.build();
        _$failedField = 'keypad';
        _keypad?.build();
        _$failedField = 'tmpItem';
        _tmpItem?.build();
        _$failedField = 'couchDbClient';
        _couchDbClient?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AppState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
