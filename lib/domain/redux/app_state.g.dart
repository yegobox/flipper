// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppState extends AppState {
  @override
  final FUser user;
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
  final Product customItem;
  @override
  final BuiltList<Unit> units;
  @override
  final BuiltList<FUser> users;
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
  final Variation variant;
  @override
  final BuiltList<Variation> itemVariations;
  @override
  final Product currentActiveSaleProduct;
  @override
  final Variation currentActiveSaleVariant;
  @override
  final Product cartItem;
  @override
  final BuiltList<Product> items;
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
  final Product tmpItem;
  @override
  final Total total;
  @override
  final Tax defaultTax;
  @override
  final CouchDbClient couchDbClient;
  @override
  final String fcmToken;
  @override
  final ImageP image;
  @override
  final String note;
  @override
  final InAppNotification inAppNotification;
  @override
  final DateFilter dateFilter;
  @override
  final Report report;
  @override
  final String navigate;
  @override
  final String phone;
  @override
  final String otpcode;

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
      this.variant,
      this.itemVariations,
      this.currentActiveSaleProduct,
      this.currentActiveSaleVariant,
      this.cartItem,
      this.items,
      this.currentIncrement,
      this.carts,
      this.cartQuantities,
      this.order,
      this.keypad,
      this.tmpItem,
      this.total,
      this.defaultTax,
      this.couchDbClient,
      this.fcmToken,
      this.image,
      this.note,
      this.inAppNotification,
      this.dateFilter,
      this.report,
      this.navigate,
      this.phone,
      this.otpcode})
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
        variant == other.variant &&
        itemVariations == other.itemVariations &&
        currentActiveSaleProduct == other.currentActiveSaleProduct &&
        currentActiveSaleVariant == other.currentActiveSaleVariant &&
        cartItem == other.cartItem &&
        items == other.items &&
        currentIncrement == other.currentIncrement &&
        carts == other.carts &&
        cartQuantities == other.cartQuantities &&
        order == other.order &&
        keypad == other.keypad &&
        tmpItem == other.tmpItem &&
        total == other.total &&
        defaultTax == other.defaultTax &&
        couchDbClient == other.couchDbClient &&
        fcmToken == other.fcmToken &&
        image == other.image &&
        note == other.note &&
        inAppNotification == other.inAppNotification &&
        dateFilter == other.dateFilter &&
        report == other.report &&
        navigate == other.navigate &&
        phone == other.phone &&
        otpcode == other.otpcode;
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
                                                                            $jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc($jc(0, user.hashCode), userId.hashCode), currentActiveBusiness.hashCode), tab.hashCode), nextActiveBusiness.hashCode), sheet.hashCode), action.hashCode), price.hashCode), businessId.hashCode), unit.hashCode), customUnit.hashCode), customItem.hashCode), units.hashCode), users.hashCode), focusedUnit.hashCode), category.hashCode), permissions.hashCode), branches.hashCode), businesses.hashCode), branch.hashCode), business.hashCode), hint.hashCode), database.hashCode), couch.hashCode), tempCategoryId.hashCode), currentUnit.hashCode), currentColor.hashCode), variant.hashCode), itemVariations.hashCode), currentActiveSaleProduct.hashCode), currentActiveSaleVariant.hashCode), cartItem.hashCode),
                                                                                items.hashCode),
                                                                            currentIncrement.hashCode),
                                                                        carts.hashCode),
                                                                    cartQuantities.hashCode),
                                                                order.hashCode),
                                                            keypad.hashCode),
                                                        tmpItem.hashCode),
                                                    total.hashCode),
                                                defaultTax.hashCode),
                                            couchDbClient.hashCode),
                                        fcmToken.hashCode),
                                    image.hashCode),
                                note.hashCode),
                            inAppNotification.hashCode),
                        dateFilter.hashCode),
                    report.hashCode),
                navigate.hashCode),
            phone.hashCode),
        otpcode.hashCode));
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
          ..add('variant', variant)
          ..add('itemVariations', itemVariations)
          ..add('currentActiveSaleProduct', currentActiveSaleProduct)
          ..add('currentActiveSaleVariant', currentActiveSaleVariant)
          ..add('cartItem', cartItem)
          ..add('items', items)
          ..add('currentIncrement', currentIncrement)
          ..add('carts', carts)
          ..add('cartQuantities', cartQuantities)
          ..add('order', order)
          ..add('keypad', keypad)
          ..add('tmpItem', tmpItem)
          ..add('total', total)
          ..add('defaultTax', defaultTax)
          ..add('couchDbClient', couchDbClient)
          ..add('fcmToken', fcmToken)
          ..add('image', image)
          ..add('note', note)
          ..add('inAppNotification', inAppNotification)
          ..add('dateFilter', dateFilter)
          ..add('report', report)
          ..add('navigate', navigate)
          ..add('phone', phone)
          ..add('otpcode', otpcode))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState _$v;

  FUserBuilder _user;
  FUserBuilder get user => _$this._user ??= new FUserBuilder();
  set user(FUserBuilder user) => _$this._user = user;

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

  ProductBuilder _customItem;
  ProductBuilder get customItem => _$this._customItem ??= new ProductBuilder();
  set customItem(ProductBuilder customItem) => _$this._customItem = customItem;

  ListBuilder<Unit> _units;
  ListBuilder<Unit> get units => _$this._units ??= new ListBuilder<Unit>();
  set units(ListBuilder<Unit> units) => _$this._units = units;

  ListBuilder<FUser> _users;
  ListBuilder<FUser> get users => _$this._users ??= new ListBuilder<FUser>();
  set users(ListBuilder<FUser> users) => _$this._users = users;

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

  VariationBuilder _variant;
  VariationBuilder get variant => _$this._variant ??= new VariationBuilder();
  set variant(VariationBuilder variant) => _$this._variant = variant;

  ListBuilder<Variation> _itemVariations;
  ListBuilder<Variation> get itemVariations =>
      _$this._itemVariations ??= new ListBuilder<Variation>();
  set itemVariations(ListBuilder<Variation> itemVariations) =>
      _$this._itemVariations = itemVariations;

  ProductBuilder _currentActiveSaleProduct;
  ProductBuilder get currentActiveSaleProduct =>
      _$this._currentActiveSaleProduct ??= new ProductBuilder();
  set currentActiveSaleProduct(ProductBuilder currentActiveSaleProduct) =>
      _$this._currentActiveSaleProduct = currentActiveSaleProduct;

  VariationBuilder _currentActiveSaleVariant;
  VariationBuilder get currentActiveSaleVariant =>
      _$this._currentActiveSaleVariant ??= new VariationBuilder();
  set currentActiveSaleVariant(VariationBuilder currentActiveSaleVariant) =>
      _$this._currentActiveSaleVariant = currentActiveSaleVariant;

  ProductBuilder _cartItem;
  ProductBuilder get cartItem => _$this._cartItem ??= new ProductBuilder();
  set cartItem(ProductBuilder cartItem) => _$this._cartItem = cartItem;

  ListBuilder<Product> _items;
  ListBuilder<Product> get items =>
      _$this._items ??= new ListBuilder<Product>();
  set items(ListBuilder<Product> items) => _$this._items = items;

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

  ProductBuilder _tmpItem;
  ProductBuilder get tmpItem => _$this._tmpItem ??= new ProductBuilder();
  set tmpItem(ProductBuilder tmpItem) => _$this._tmpItem = tmpItem;

  TotalBuilder _total;
  TotalBuilder get total => _$this._total ??= new TotalBuilder();
  set total(TotalBuilder total) => _$this._total = total;

  TaxBuilder _defaultTax;
  TaxBuilder get defaultTax => _$this._defaultTax ??= new TaxBuilder();
  set defaultTax(TaxBuilder defaultTax) => _$this._defaultTax = defaultTax;

  CouchDbClientBuilder _couchDbClient;
  CouchDbClientBuilder get couchDbClient =>
      _$this._couchDbClient ??= new CouchDbClientBuilder();
  set couchDbClient(CouchDbClientBuilder couchDbClient) =>
      _$this._couchDbClient = couchDbClient;

  String _fcmToken;
  String get fcmToken => _$this._fcmToken;
  set fcmToken(String fcmToken) => _$this._fcmToken = fcmToken;

  ImagePBuilder _image;
  ImagePBuilder get image => _$this._image ??= new ImagePBuilder();
  set image(ImagePBuilder image) => _$this._image = image;

  String _note;
  String get note => _$this._note;
  set note(String note) => _$this._note = note;

  InAppNotificationBuilder _inAppNotification;
  InAppNotificationBuilder get inAppNotification =>
      _$this._inAppNotification ??= new InAppNotificationBuilder();
  set inAppNotification(InAppNotificationBuilder inAppNotification) =>
      _$this._inAppNotification = inAppNotification;

  DateFilterBuilder _dateFilter;
  DateFilterBuilder get dateFilter =>
      _$this._dateFilter ??= new DateFilterBuilder();
  set dateFilter(DateFilterBuilder dateFilter) =>
      _$this._dateFilter = dateFilter;

  ReportBuilder _report;
  ReportBuilder get report => _$this._report ??= new ReportBuilder();
  set report(ReportBuilder report) => _$this._report = report;

  String _navigate;
  String get navigate => _$this._navigate;
  set navigate(String navigate) => _$this._navigate = navigate;

  String _phone;
  String get phone => _$this._phone;
  set phone(String phone) => _$this._phone = phone;

  String _otpcode;
  String get otpcode => _$this._otpcode;
  set otpcode(String otpcode) => _$this._otpcode = otpcode;

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
      _variant = _$v.variant?.toBuilder();
      _itemVariations = _$v.itemVariations?.toBuilder();
      _currentActiveSaleProduct = _$v.currentActiveSaleProduct?.toBuilder();
      _currentActiveSaleVariant = _$v.currentActiveSaleVariant?.toBuilder();
      _cartItem = _$v.cartItem?.toBuilder();
      _items = _$v.items?.toBuilder();
      _currentIncrement = _$v.currentIncrement;
      _carts = _$v.carts?.toBuilder();
      _cartQuantities = _$v.cartQuantities;
      _order = _$v.order?.toBuilder();
      _keypad = _$v.keypad?.toBuilder();
      _tmpItem = _$v.tmpItem?.toBuilder();
      _total = _$v.total?.toBuilder();
      _defaultTax = _$v.defaultTax?.toBuilder();
      _couchDbClient = _$v.couchDbClient?.toBuilder();
      _fcmToken = _$v.fcmToken;
      _image = _$v.image?.toBuilder();
      _note = _$v.note;
      _inAppNotification = _$v.inAppNotification?.toBuilder();
      _dateFilter = _$v.dateFilter?.toBuilder();
      _report = _$v.report?.toBuilder();
      _navigate = _$v.navigate;
      _phone = _$v.phone;
      _otpcode = _$v.otpcode;
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
              variant: _variant?.build(),
              itemVariations: itemVariations.build(),
              currentActiveSaleProduct: _currentActiveSaleProduct?.build(),
              currentActiveSaleVariant: _currentActiveSaleVariant?.build(),
              cartItem: _cartItem?.build(),
              items: items.build(),
              currentIncrement: currentIncrement,
              carts: carts.build(),
              cartQuantities: cartQuantities,
              order: _order?.build(),
              keypad: _keypad?.build(),
              tmpItem: _tmpItem?.build(),
              total: _total?.build(),
              defaultTax: _defaultTax?.build(),
              couchDbClient: _couchDbClient?.build(),
              fcmToken: fcmToken,
              image: _image?.build(),
              note: note,
              inAppNotification: _inAppNotification?.build(),
              dateFilter: _dateFilter?.build(),
              report: _report?.build(),
              navigate: navigate,
              phone: phone,
              otpcode: otpcode);
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
        _$failedField = 'variant';
        _variant?.build();
        _$failedField = 'itemVariations';
        itemVariations.build();
        _$failedField = 'currentActiveSaleProduct';
        _currentActiveSaleProduct?.build();
        _$failedField = 'currentActiveSaleVariant';
        _currentActiveSaleVariant?.build();
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
        _$failedField = 'total';
        _total?.build();
        _$failedField = 'defaultTax';
        _defaultTax?.build();
        _$failedField = 'couchDbClient';
        _couchDbClient?.build();

        _$failedField = 'image';
        _image?.build();

        _$failedField = 'inAppNotification';
        _inAppNotification?.build();
        _$failedField = 'dateFilter';
        _dateFilter?.build();
        _$failedField = 'report';
        _report?.build();
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
