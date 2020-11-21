// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_view_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CommonViewModel extends CommonViewModel {
  @override
  final BuiltList<Unit> units;
  @override
  final Business currentBusiness;
  @override
  final List<Branch> branches;
  @override
  final List<Business> businesses;
  @override
  final Hint hint;
  @override
  final Category category;
  @override
  final String otpcode;
  @override
  final Branch branch;
  @override
  final PColor currentColor;
  @override
  final FUser user;
  @override
  final Product customItem;
  @override
  final Product tmpItem;
  @override
  final ImageP image;
  @override
  final String note;

  factory _$CommonViewModel([void Function(CommonViewModelBuilder) updates]) =>
      (new CommonViewModelBuilder()..update(updates)).build();

  _$CommonViewModel._(
      {this.units,
      this.currentBusiness,
      this.branches,
      this.businesses,
      this.hint,
      this.category,
      this.otpcode,
      this.branch,
      this.currentColor,
      this.user,
      this.customItem,
      this.tmpItem,
      this.image,
      this.note})
      : super._() {
    if (branches == null) {
      throw new BuiltValueNullFieldError('CommonViewModel', 'branches');
    }
    if (businesses == null) {
      throw new BuiltValueNullFieldError('CommonViewModel', 'businesses');
    }
  }

  @override
  CommonViewModel rebuild(void Function(CommonViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CommonViewModelBuilder toBuilder() =>
      new CommonViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CommonViewModel &&
        units == other.units &&
        currentBusiness == other.currentBusiness &&
        branches == other.branches &&
        businesses == other.businesses &&
        hint == other.hint &&
        category == other.category &&
        otpcode == other.otpcode &&
        branch == other.branch &&
        currentColor == other.currentColor &&
        user == other.user &&
        customItem == other.customItem &&
        tmpItem == other.tmpItem &&
        image == other.image &&
        note == other.note;
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
                                                        $jc(0, units.hashCode),
                                                        currentBusiness
                                                            .hashCode),
                                                    branches.hashCode),
                                                businesses.hashCode),
                                            hint.hashCode),
                                        category.hashCode),
                                    otpcode.hashCode),
                                branch.hashCode),
                            currentColor.hashCode),
                        user.hashCode),
                    customItem.hashCode),
                tmpItem.hashCode),
            image.hashCode),
        note.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CommonViewModel')
          ..add('units', units)
          ..add('currentBusiness', currentBusiness)
          ..add('branches', branches)
          ..add('businesses', businesses)
          ..add('hint', hint)
          ..add('category', category)
          ..add('otpcode', otpcode)
          ..add('branch', branch)
          ..add('currentColor', currentColor)
          ..add('user', user)
          ..add('customItem', customItem)
          ..add('tmpItem', tmpItem)
          ..add('image', image)
          ..add('note', note))
        .toString();
  }
}

class CommonViewModelBuilder
    implements Builder<CommonViewModel, CommonViewModelBuilder> {
  _$CommonViewModel _$v;

  ListBuilder<Unit> _units;
  ListBuilder<Unit> get units => _$this._units ??= new ListBuilder<Unit>();
  set units(ListBuilder<Unit> units) => _$this._units = units;

  BusinessBuilder _currentBusiness;
  BusinessBuilder get currentBusiness =>
      _$this._currentBusiness ??= new BusinessBuilder();
  set currentBusiness(BusinessBuilder currentBusiness) =>
      _$this._currentBusiness = currentBusiness;

  List<Branch> _branches;
  List<Branch> get branches => _$this._branches;
  set branches(List<Branch> branches) => _$this._branches = branches;

  List<Business> _businesses;
  List<Business> get businesses => _$this._businesses;
  set businesses(List<Business> businesses) => _$this._businesses = businesses;

  HintBuilder _hint;
  HintBuilder get hint => _$this._hint ??= new HintBuilder();
  set hint(HintBuilder hint) => _$this._hint = hint;

  CategoryBuilder _category;
  CategoryBuilder get category => _$this._category ??= new CategoryBuilder();
  set category(CategoryBuilder category) => _$this._category = category;

  String _otpcode;
  String get otpcode => _$this._otpcode;
  set otpcode(String otpcode) => _$this._otpcode = otpcode;

  BranchBuilder _branch;
  BranchBuilder get branch => _$this._branch ??= new BranchBuilder();
  set branch(BranchBuilder branch) => _$this._branch = branch;

  PColorBuilder _currentColor;
  PColorBuilder get currentColor =>
      _$this._currentColor ??= new PColorBuilder();
  set currentColor(PColorBuilder currentColor) =>
      _$this._currentColor = currentColor;

  FUserBuilder _user;
  FUserBuilder get user => _$this._user ??= new FUserBuilder();
  set user(FUserBuilder user) => _$this._user = user;

  ProductBuilder _customItem;
  ProductBuilder get customItem => _$this._customItem ??= new ProductBuilder();
  set customItem(ProductBuilder customItem) => _$this._customItem = customItem;

  ProductBuilder _tmpItem;
  ProductBuilder get tmpItem => _$this._tmpItem ??= new ProductBuilder();
  set tmpItem(ProductBuilder tmpItem) => _$this._tmpItem = tmpItem;

  ImagePBuilder _image;
  ImagePBuilder get image => _$this._image ??= new ImagePBuilder();
  set image(ImagePBuilder image) => _$this._image = image;

  String _note;
  String get note => _$this._note;
  set note(String note) => _$this._note = note;

  CommonViewModelBuilder();

  CommonViewModelBuilder get _$this {
    if (_$v != null) {
      _units = _$v.units?.toBuilder();
      _currentBusiness = _$v.currentBusiness?.toBuilder();
      _branches = _$v.branches;
      _businesses = _$v.businesses;
      _hint = _$v.hint?.toBuilder();
      _category = _$v.category?.toBuilder();
      _otpcode = _$v.otpcode;
      _branch = _$v.branch?.toBuilder();
      _currentColor = _$v.currentColor?.toBuilder();
      _user = _$v.user?.toBuilder();
      _customItem = _$v.customItem?.toBuilder();
      _tmpItem = _$v.tmpItem?.toBuilder();
      _image = _$v.image?.toBuilder();
      _note = _$v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CommonViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CommonViewModel;
  }

  @override
  void update(void Function(CommonViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CommonViewModel build() {
    _$CommonViewModel _$result;
    try {
      _$result = _$v ??
          new _$CommonViewModel._(
              units: _units?.build(),
              currentBusiness: _currentBusiness?.build(),
              branches: branches,
              businesses: businesses,
              hint: _hint?.build(),
              category: _category?.build(),
              otpcode: otpcode,
              branch: _branch?.build(),
              currentColor: _currentColor?.build(),
              user: _user?.build(),
              customItem: _customItem?.build(),
              tmpItem: _tmpItem?.build(),
              image: _image?.build(),
              note: note);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'units';
        _units?.build();
        _$failedField = 'currentBusiness';
        _currentBusiness?.build();

        _$failedField = 'hint';
        _hint?.build();
        _$failedField = 'category';
        _category?.build();

        _$failedField = 'branch';
        _branch?.build();
        _$failedField = 'currentColor';
        _currentColor?.build();
        _$failedField = 'user';
        _user?.build();
        _$failedField = 'customItem';
        _customItem?.build();
        _$failedField = 'tmpItem';
        _tmpItem?.build();
        _$failedField = 'image';
        _image?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'CommonViewModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
