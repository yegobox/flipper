// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppState extends AppState {
  @override
  final FUser user;
  @override
  final Business currentActiveBusiness;
  @override
  final Unit unit;
  @override
  final String otpcode;
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
  final String tempCategoryId;
  @override
  final Variation variant;
  @override
  final BuiltList<Product> items;
  @override
  final Order order;
  @override
  final Product tmpItem;
  @override
  final String fcmToken;
  @override
  final ImageP image;
  @override
  final String note;
  @override
  final InAppNotification inAppNotification;
  @override
  final Report report;

  factory _$AppState([void Function(AppStateBuilder) updates]) =>
      (new AppStateBuilder()..update(updates)).build();

  _$AppState._(
      {this.user,
      this.currentActiveBusiness,
      this.unit,
      this.otpcode,
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
      this.tempCategoryId,
      this.variant,
      this.items,
      this.order,
      this.tmpItem,
      this.fcmToken,
      this.image,
      this.note,
      this.inAppNotification,
      this.report})
      : super._() {
    if (items == null) {
      throw new BuiltValueNullFieldError('AppState', 'items');
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
        currentActiveBusiness == other.currentActiveBusiness &&
        unit == other.unit &&
        otpcode == other.otpcode &&
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
        tempCategoryId == other.tempCategoryId &&
        variant == other.variant &&
        items == other.items &&
        order == other.order &&
        tmpItem == other.tmpItem &&
        fcmToken == other.fcmToken &&
        image == other.image &&
        note == other.note &&
        inAppNotification == other.inAppNotification &&
        report == other.report;
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
                                                                            $jc($jc($jc($jc($jc($jc(0, user.hashCode), currentActiveBusiness.hashCode), unit.hashCode), otpcode.hashCode), units.hashCode),
                                                                                users.hashCode),
                                                                            focusedUnit.hashCode),
                                                                        category.hashCode),
                                                                    permissions.hashCode),
                                                                branches.hashCode),
                                                            businesses.hashCode),
                                                        branch.hashCode),
                                                    business.hashCode),
                                                hint.hashCode),
                                            tempCategoryId.hashCode),
                                        variant.hashCode),
                                    items.hashCode),
                                order.hashCode),
                            tmpItem.hashCode),
                        fcmToken.hashCode),
                    image.hashCode),
                note.hashCode),
            inAppNotification.hashCode),
        report.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppState')
          ..add('user', user)
          ..add('currentActiveBusiness', currentActiveBusiness)
          ..add('unit', unit)
          ..add('otpcode', otpcode)
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
          ..add('tempCategoryId', tempCategoryId)
          ..add('variant', variant)
          ..add('items', items)
          ..add('order', order)
          ..add('tmpItem', tmpItem)
          ..add('fcmToken', fcmToken)
          ..add('image', image)
          ..add('note', note)
          ..add('inAppNotification', inAppNotification)
          ..add('report', report))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState _$v;

  FUserBuilder _user;
  FUserBuilder get user => _$this._user ??= new FUserBuilder();
  set user(FUserBuilder user) => _$this._user = user;

  BusinessBuilder _currentActiveBusiness;
  BusinessBuilder get currentActiveBusiness =>
      _$this._currentActiveBusiness ??= new BusinessBuilder();
  set currentActiveBusiness(BusinessBuilder currentActiveBusiness) =>
      _$this._currentActiveBusiness = currentActiveBusiness;

  UnitBuilder _unit;
  UnitBuilder get unit => _$this._unit ??= new UnitBuilder();
  set unit(UnitBuilder unit) => _$this._unit = unit;

  String _otpcode;
  String get otpcode => _$this._otpcode;
  set otpcode(String otpcode) => _$this._otpcode = otpcode;

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

  String _tempCategoryId;
  String get tempCategoryId => _$this._tempCategoryId;
  set tempCategoryId(String tempCategoryId) =>
      _$this._tempCategoryId = tempCategoryId;

  VariationBuilder _variant;
  VariationBuilder get variant => _$this._variant ??= new VariationBuilder();
  set variant(VariationBuilder variant) => _$this._variant = variant;

  ListBuilder<Product> _items;
  ListBuilder<Product> get items =>
      _$this._items ??= new ListBuilder<Product>();
  set items(ListBuilder<Product> items) => _$this._items = items;

  OrderBuilder _order;
  OrderBuilder get order => _$this._order ??= new OrderBuilder();
  set order(OrderBuilder order) => _$this._order = order;

  ProductBuilder _tmpItem;
  ProductBuilder get tmpItem => _$this._tmpItem ??= new ProductBuilder();
  set tmpItem(ProductBuilder tmpItem) => _$this._tmpItem = tmpItem;

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

  ReportBuilder _report;
  ReportBuilder get report => _$this._report ??= new ReportBuilder();
  set report(ReportBuilder report) => _$this._report = report;

  AppStateBuilder();

  AppStateBuilder get _$this {
    if (_$v != null) {
      _user = _$v.user?.toBuilder();
      _currentActiveBusiness = _$v.currentActiveBusiness?.toBuilder();
      _unit = _$v.unit?.toBuilder();
      _otpcode = _$v.otpcode;
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
      _tempCategoryId = _$v.tempCategoryId;
      _variant = _$v.variant?.toBuilder();
      _items = _$v.items?.toBuilder();
      _order = _$v.order?.toBuilder();
      _tmpItem = _$v.tmpItem?.toBuilder();
      _fcmToken = _$v.fcmToken;
      _image = _$v.image?.toBuilder();
      _note = _$v.note;
      _inAppNotification = _$v.inAppNotification?.toBuilder();
      _report = _$v.report?.toBuilder();
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
              currentActiveBusiness: _currentActiveBusiness?.build(),
              unit: _unit?.build(),
              otpcode: otpcode,
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
              tempCategoryId: tempCategoryId,
              variant: _variant?.build(),
              items: items.build(),
              order: _order?.build(),
              tmpItem: _tmpItem?.build(),
              fcmToken: fcmToken,
              image: _image?.build(),
              note: note,
              inAppNotification: _inAppNotification?.build(),
              report: _report?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'user';
        _user?.build();
        _$failedField = 'currentActiveBusiness';
        _currentActiveBusiness?.build();
        _$failedField = 'unit';
        _unit?.build();

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

        _$failedField = 'variant';
        _variant?.build();
        _$failedField = 'items';
        items.build();
        _$failedField = 'order';
        _order?.build();
        _$failedField = 'tmpItem';
        _tmpItem?.build();

        _$failedField = 'image';
        _image?.build();

        _$failedField = 'inAppNotification';
        _inAppNotification?.build();
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
