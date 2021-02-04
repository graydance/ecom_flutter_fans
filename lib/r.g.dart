// IT IS GENERATED BY FLR - DO NOT MODIFY BY HAND
// YOU CAN GET MORE DETAILS ABOUT FLR FROM:
// - https://github.com/Fly-Mix/flr-cli
// - https://github.com/Fly-Mix/flr-vscode-extension
// - https://github.com/Fly-Mix/flr-as-plugin
//

// ignore: unused_import
import 'package:flutter/widgets.dart';
// ignore: unused_import
import 'package:flutter/services.dart' show rootBundle;
// ignore: unused_import
import 'package:path/path.dart' as path;
// ignore: unused_import
import 'package:flutter_svg/flutter_svg.dart';
// ignore: unused_import
import 'package:r_dart_library/asset_svg.dart';

/// This `R` class is generated and contains references to static asset resources.
class R {
  /// package name: fans
  static const package = "fans";

  /// This `R.image` struct is generated, and contains static references to static non-svg type image asset resources.
  static const image = _R_Image();

  /// This `R.svg` struct is generated, and contains static references to static svg type image asset resources.
  static const svg = _R_Svg();

  /// This `R.text` struct is generated, and contains static references to static text asset resources.
  static const text = _R_Text();

  /// This `R.fontFamily` struct is generated, and contains static references to static font asset resources.
  static const fontFamily = _R_FontFamily();
}

/// Asset resource’s metadata class.
/// For example, here is the metadata of `packages/flutter_demo/assets/images/example.png` asset:
/// - packageName：flutter_demo
/// - assetName：assets/images/example.png
/// - fileDirname：assets/images
/// - fileBasename：example.png
/// - fileBasenameNoExtension：example
/// - fileExtname：.png
class AssetResource {
  /// Creates an object to hold the asset resource’s metadata.
  const AssetResource(this.assetName, {this.packageName}) : assert(assetName != null);

  /// The name of the main asset from the set of asset resources to choose from.
  final String assetName;

  /// The name of the package from which the asset resource is included.
  final String packageName;

  /// The name used to generate the key to obtain the asset resource. For local assets
  /// this is [assetName], and for assets from packages the [assetName] is
  /// prefixed 'packages/<package_name>/'.
  String get keyName => packageName == null ? assetName : "packages/$packageName/$assetName";

  /// The file basename of the asset resource.
  String get fileBasename {
    final basename = path.basename(assetName);
    return basename;
  }

  /// The no extension file basename of the asset resource.
  String get fileBasenameNoExtension {
    final basenameWithoutExtension = path.basenameWithoutExtension(assetName);
    return basenameWithoutExtension;
  }

  /// The file extension name of the asset resource.
  String get fileExtname {
    final extension = path.extension(assetName);
    return extension;
  }

  /// The directory path name of the asset resource.
  String get fileDirname {
    var dirname = assetName;
    if (packageName != null) {
      final packageStr = "packages/$packageName/";
      dirname = dirname.replaceAll(packageStr, "");
    }
    final filenameStr = "$fileBasename/";
    dirname = dirname.replaceAll(filenameStr, "");
    return dirname;
  }
}

// ignore: camel_case_types
class _R_Image_AssetResource {
  const _R_Image_AssetResource();

  /// asset: assets/images/auth/auth_background.png
  // ignore: non_constant_identifier_names
  final auth_background =
      const AssetResource("assets/images/auth/auth_background.png", packageName: null);

  /// asset: assets/images/auth/eyes_visibility.png
  // ignore: non_constant_identifier_names
  final eyes_visibility =
      const AssetResource("assets/images/auth/eyes_visibility.png", packageName: null);

  /// asset: assets/images/auth/eyes_visibility_off.png
  // ignore: non_constant_identifier_names
  final eyes_visibility_off =
      const AssetResource("assets/images/auth/eyes_visibility_off.png", packageName: null);

  /// asset: assets/images/auth/interest_selected.png
  // ignore: non_constant_identifier_names
  final interest_selected =
      const AssetResource("assets/images/auth/interest_selected.png", packageName: null);

  /// asset: assets/images/auth/interest_unselected.png
  // ignore: non_constant_identifier_names
  final interest_unselected =
      const AssetResource("assets/images/auth/interest_unselected.png", packageName: null);

  /// asset: assets/images/feed/ad_avatar_placeholder.png
  // ignore: non_constant_identifier_names
  final ad_avatar_placeholder =
      const AssetResource("assets/images/feed/ad_avatar_placeholder.png", packageName: null);

  /// asset: assets/images/feed/add_cart.png
  // ignore: non_constant_identifier_names
  final add_cart = const AssetResource("assets/images/feed/add_cart.png", packageName: null);

  /// asset: assets/images/feed/avatar_placeholder.png
  // ignore: non_constant_identifier_names
  final avatar_placeholder =
      const AssetResource("assets/images/feed/avatar_placeholder.png", packageName: null);

  /// asset: assets/images/feed/cart.png
  // ignore: non_constant_identifier_names
  final cart = const AssetResource("assets/images/feed/cart.png", packageName: null);

  /// asset: assets/images/feed/favorite.png
  // ignore: non_constant_identifier_names
  final favorite = const AssetResource("assets/images/feed/favorite.png", packageName: null);

  /// asset: assets/images/feed/more_vert.png
  // ignore: non_constant_identifier_names
  final more_vert = const AssetResource("assets/images/feed/more_vert.png", packageName: null);

  /// asset: assets/images/feed/new_msg_tip_bg.png
  // ignore: non_constant_identifier_names
  final new_msg_tip_bg =
      const AssetResource("assets/images/feed/new_msg_tip_bg.png", packageName: null);

  /// asset: assets/images/feed/pause.png
  // ignore: non_constant_identifier_names
  final pause = const AssetResource("assets/images/feed/pause.png", packageName: null);

  /// asset: assets/images/feed/play.png
  // ignore: non_constant_identifier_names
  final play = const AssetResource("assets/images/feed/play.png", packageName: null);

  /// asset: assets/images/feed/product_mask_bg.png
  // ignore: non_constant_identifier_names
  final product_mask_bg =
      const AssetResource("assets/images/feed/product_mask_bg.png", packageName: null);

  /// asset: assets/images/feed/shopping_cart.png
  // ignore: non_constant_identifier_names
  final shopping_cart =
      const AssetResource("assets/images/feed/shopping_cart.png", packageName: null);

  /// asset: assets/images/feed/verified.png
  // ignore: non_constant_identifier_names
  final verified = const AssetResource("assets/images/feed/verified.png", packageName: null);

  /// asset: assets/images/feed/voice_mute.png
  // ignore: non_constant_identifier_names
  final voice_mute = const AssetResource("assets/images/feed/voice_mute.png", packageName: null);

  /// asset: assets/images/feed/voice_unmute.png
  // ignore: non_constant_identifier_names
  final voice_unmute =
      const AssetResource("assets/images/feed/voice_unmute.png", packageName: null);

  /// asset: assets/images/kol/kol_album_bg.png
  // ignore: non_constant_identifier_names
  final kol_album_bg = const AssetResource("assets/images/kol/kol_album_bg.png", packageName: null);

  /// asset: assets/images/kol/kol_cart.png
  // ignore: non_constant_identifier_names
  final kol_cart = const AssetResource("assets/images/kol/kol_cart.png", packageName: null);

  /// asset: assets/images/kol/kol_detail_bg.png
  // ignore: non_constant_identifier_names
  final kol_detail_bg =
      const AssetResource("assets/images/kol/kol_detail_bg.png", packageName: null);

  /// asset: assets/images/kol/kol_tab_album.png
  // ignore: non_constant_identifier_names
  final kol_tab_album =
      const AssetResource("assets/images/kol/kol_tab_album.png", packageName: null);

  /// asset: assets/images/kol/kol_tab_album_unselected.png
  // ignore: non_constant_identifier_names
  final kol_tab_album_unselected =
      const AssetResource("assets/images/kol/kol_tab_album_unselected.png", packageName: null);

  /// asset: assets/images/kol/kol_tab_photos.png
  // ignore: non_constant_identifier_names
  final kol_tab_photos =
      const AssetResource("assets/images/kol/kol_tab_photos.png", packageName: null);

  /// asset: assets/images/kol/kol_tab_photos_unselected.png
  // ignore: non_constant_identifier_names
  final kol_tab_photos_unselected =
      const AssetResource("assets/images/kol/kol_tab_photos_unselected.png", packageName: null);

  /// asset: assets/images/logo.png
  // ignore: non_constant_identifier_names
  final logo = const AssetResource("assets/images/logo.png", packageName: null);

  /// asset: assets/images/product/icon_payment.png
  // ignore: non_constant_identifier_names
  final icon_payment =
      const AssetResource("assets/images/product/icon_payment.png", packageName: null);

  /// asset: assets/images/product/icon_shipping.png
  // ignore: non_constant_identifier_names
  final icon_shipping =
      const AssetResource("assets/images/product/icon_shipping.png", packageName: null);

  /// asset: assets/images/product/payment_success.png
  // ignore: non_constant_identifier_names
  final payment_success =
      const AssetResource("assets/images/product/payment_success.png", packageName: null);

  /// asset: assets/images/product/product_search.png
  // ignore: non_constant_identifier_names
  final product_search =
      const AssetResource("assets/images/product/product_search.png", packageName: null);

  /// asset: assets/images/tabbar/tabbar_home_highlight.png
  // ignore: non_constant_identifier_names
  final tabbar_home_highlight =
      const AssetResource("assets/images/tabbar/tabbar_home_highlight.png", packageName: null);

  /// asset: assets/images/tabbar/tabbar_home_normal.png
  // ignore: non_constant_identifier_names
  final tabbar_home_normal =
      const AssetResource("assets/images/tabbar/tabbar_home_normal.png", packageName: null);

  /// asset: assets/images/tabbar/tabbar_inbox_hightlight.png
  // ignore: non_constant_identifier_names
  final tabbar_inbox_hightlight =
      const AssetResource("assets/images/tabbar/tabbar_inbox_hightlight.png", packageName: null);

  /// asset: assets/images/tabbar/tabbar_inbox_normal.png
  // ignore: non_constant_identifier_names
  final tabbar_inbox_normal =
      const AssetResource("assets/images/tabbar/tabbar_inbox_normal.png", packageName: null);

  /// asset: assets/images/tabbar/tabbar_profile_hightlight.png
  // ignore: non_constant_identifier_names
  final tabbar_profile_hightlight =
      const AssetResource("assets/images/tabbar/tabbar_profile_hightlight.png", packageName: null);

  /// asset: assets/images/tabbar/tabbar_profile_normal.png
  // ignore: non_constant_identifier_names
  final tabbar_profile_normal =
      const AssetResource("assets/images/tabbar/tabbar_profile_normal.png", packageName: null);

  /// asset: assets/images/tabbar/tabbar_search_highlight.png
  // ignore: non_constant_identifier_names
  final tabbar_search_highlight =
      const AssetResource("assets/images/tabbar/tabbar_search_highlight.png", packageName: null);

  /// asset: assets/images/tabbar/tabbar_search_normal.png
  // ignore: non_constant_identifier_names
  final tabbar_search_normal =
      const AssetResource("assets/images/tabbar/tabbar_search_normal.png", packageName: null);
}

// ignore: camel_case_types
class _R_Svg_AssetResource {
  const _R_Svg_AssetResource();
}

// ignore: camel_case_types
class _R_Text_AssetResource {
  const _R_Text_AssetResource();
}

/// This `_R_Image` class is generated and contains references to static non-svg type image asset resources.
// ignore: camel_case_types
class _R_Image {
  const _R_Image();

  final asset = const _R_Image_AssetResource();

  /// asset: assets/images/auth/auth_background.png
  // ignore: non_constant_identifier_names
  AssetImage auth_background() {
    return AssetImage(asset.auth_background.keyName);
  }

  /// asset: assets/images/auth/eyes_visibility.png
  // ignore: non_constant_identifier_names
  AssetImage eyes_visibility() {
    return AssetImage(asset.eyes_visibility.keyName);
  }

  /// asset: assets/images/auth/eyes_visibility_off.png
  // ignore: non_constant_identifier_names
  AssetImage eyes_visibility_off() {
    return AssetImage(asset.eyes_visibility_off.keyName);
  }

  /// asset: assets/images/auth/interest_selected.png
  // ignore: non_constant_identifier_names
  AssetImage interest_selected() {
    return AssetImage(asset.interest_selected.keyName);
  }

  /// asset: assets/images/auth/interest_unselected.png
  // ignore: non_constant_identifier_names
  AssetImage interest_unselected() {
    return AssetImage(asset.interest_unselected.keyName);
  }

  /// asset: assets/images/feed/ad_avatar_placeholder.png
  // ignore: non_constant_identifier_names
  AssetImage ad_avatar_placeholder() {
    return AssetImage(asset.ad_avatar_placeholder.keyName);
  }

  /// asset: assets/images/feed/add_cart.png
  // ignore: non_constant_identifier_names
  AssetImage add_cart() {
    return AssetImage(asset.add_cart.keyName);
  }

  /// asset: assets/images/feed/avatar_placeholder.png
  // ignore: non_constant_identifier_names
  AssetImage avatar_placeholder() {
    return AssetImage(asset.avatar_placeholder.keyName);
  }

  /// asset: assets/images/feed/cart.png
  // ignore: non_constant_identifier_names
  AssetImage cart() {
    return AssetImage(asset.cart.keyName);
  }

  /// asset: assets/images/feed/favorite.png
  // ignore: non_constant_identifier_names
  AssetImage favorite() {
    return AssetImage(asset.favorite.keyName);
  }

  /// asset: assets/images/feed/more_vert.png
  // ignore: non_constant_identifier_names
  AssetImage more_vert() {
    return AssetImage(asset.more_vert.keyName);
  }

  /// asset: assets/images/feed/new_msg_tip_bg.png
  // ignore: non_constant_identifier_names
  AssetImage new_msg_tip_bg() {
    return AssetImage(asset.new_msg_tip_bg.keyName);
  }

  /// asset: assets/images/feed/pause.png
  // ignore: non_constant_identifier_names
  AssetImage pause() {
    return AssetImage(asset.pause.keyName);
  }

  /// asset: assets/images/feed/play.png
  // ignore: non_constant_identifier_names
  AssetImage play() {
    return AssetImage(asset.play.keyName);
  }

  /// asset: assets/images/feed/product_mask_bg.png
  // ignore: non_constant_identifier_names
  AssetImage product_mask_bg() {
    return AssetImage(asset.product_mask_bg.keyName);
  }

  /// asset: assets/images/feed/shopping_cart.png
  // ignore: non_constant_identifier_names
  AssetImage shopping_cart() {
    return AssetImage(asset.shopping_cart.keyName);
  }

  /// asset: assets/images/feed/verified.png
  // ignore: non_constant_identifier_names
  AssetImage verified() {
    return AssetImage(asset.verified.keyName);
  }

  /// asset: assets/images/feed/voice_mute.png
  // ignore: non_constant_identifier_names
  AssetImage voice_mute() {
    return AssetImage(asset.voice_mute.keyName);
  }

  /// asset: assets/images/feed/voice_unmute.png
  // ignore: non_constant_identifier_names
  AssetImage voice_unmute() {
    return AssetImage(asset.voice_unmute.keyName);
  }

  /// asset: assets/images/kol/kol_album_bg.png
  // ignore: non_constant_identifier_names
  AssetImage kol_album_bg() {
    return AssetImage(asset.kol_album_bg.keyName);
  }

  /// asset: assets/images/kol/kol_cart.png
  // ignore: non_constant_identifier_names
  AssetImage kol_cart() {
    return AssetImage(asset.kol_cart.keyName);
  }

  /// asset: assets/images/kol/kol_detail_bg.png
  // ignore: non_constant_identifier_names
  AssetImage kol_detail_bg() {
    return AssetImage(asset.kol_detail_bg.keyName);
  }

  /// asset: assets/images/kol/kol_tab_album.png
  // ignore: non_constant_identifier_names
  AssetImage kol_tab_album() {
    return AssetImage(asset.kol_tab_album.keyName);
  }

  /// asset: assets/images/kol/kol_tab_album_unselected.png
  // ignore: non_constant_identifier_names
  AssetImage kol_tab_album_unselected() {
    return AssetImage(asset.kol_tab_album_unselected.keyName);
  }

  /// asset: assets/images/kol/kol_tab_photos.png
  // ignore: non_constant_identifier_names
  AssetImage kol_tab_photos() {
    return AssetImage(asset.kol_tab_photos.keyName);
  }

  /// asset: assets/images/kol/kol_tab_photos_unselected.png
  // ignore: non_constant_identifier_names
  AssetImage kol_tab_photos_unselected() {
    return AssetImage(asset.kol_tab_photos_unselected.keyName);
  }

  /// asset: assets/images/logo.png
  // ignore: non_constant_identifier_names
  AssetImage logo() {
    return AssetImage(asset.logo.keyName);
  }

  /// asset: assets/images/product/icon_payment.png
  // ignore: non_constant_identifier_names
  AssetImage icon_payment() {
    return AssetImage(asset.icon_payment.keyName);
  }

  /// asset: assets/images/product/icon_shipping.png
  // ignore: non_constant_identifier_names
  AssetImage icon_shipping() {
    return AssetImage(asset.icon_shipping.keyName);
  }

  /// asset: assets/images/product/payment_success.png
  // ignore: non_constant_identifier_names
  AssetImage payment_success() {
    return AssetImage(asset.payment_success.keyName);
  }

  /// asset: assets/images/product/product_search.png
  // ignore: non_constant_identifier_names
  AssetImage product_search() {
    return AssetImage(asset.product_search.keyName);
  }

  /// asset: assets/images/tabbar/tabbar_home_highlight.png
  // ignore: non_constant_identifier_names
  AssetImage tabbar_home_highlight() {
    return AssetImage(asset.tabbar_home_highlight.keyName);
  }

  /// asset: assets/images/tabbar/tabbar_home_normal.png
  // ignore: non_constant_identifier_names
  AssetImage tabbar_home_normal() {
    return AssetImage(asset.tabbar_home_normal.keyName);
  }

  /// asset: assets/images/tabbar/tabbar_inbox_hightlight.png
  // ignore: non_constant_identifier_names
  AssetImage tabbar_inbox_hightlight() {
    return AssetImage(asset.tabbar_inbox_hightlight.keyName);
  }

  /// asset: assets/images/tabbar/tabbar_inbox_normal.png
  // ignore: non_constant_identifier_names
  AssetImage tabbar_inbox_normal() {
    return AssetImage(asset.tabbar_inbox_normal.keyName);
  }

  /// asset: assets/images/tabbar/tabbar_profile_hightlight.png
  // ignore: non_constant_identifier_names
  AssetImage tabbar_profile_hightlight() {
    return AssetImage(asset.tabbar_profile_hightlight.keyName);
  }

  /// asset: assets/images/tabbar/tabbar_profile_normal.png
  // ignore: non_constant_identifier_names
  AssetImage tabbar_profile_normal() {
    return AssetImage(asset.tabbar_profile_normal.keyName);
  }

  /// asset: assets/images/tabbar/tabbar_search_highlight.png
  // ignore: non_constant_identifier_names
  AssetImage tabbar_search_highlight() {
    return AssetImage(asset.tabbar_search_highlight.keyName);
  }

  /// asset: assets/images/tabbar/tabbar_search_normal.png
  // ignore: non_constant_identifier_names
  AssetImage tabbar_search_normal() {
    return AssetImage(asset.tabbar_search_normal.keyName);
  }
}

/// This `_R_Svg` class is generated and contains references to static svg type image asset resources.
// ignore: camel_case_types
class _R_Svg {
  const _R_Svg();

  final asset = const _R_Svg_AssetResource();
}

/// This `_R_Text` class is generated and contains references to static text asset resources.
// ignore: camel_case_types
class _R_Text {
  const _R_Text();

  final asset = const _R_Text_AssetResource();
}

/// This `_R_FontFamily` class is generated and contains references to static font asset resources.
// ignore: camel_case_types
class _R_FontFamily {
  const _R_FontFamily();
}
