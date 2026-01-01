import 'package:mockito/mockito.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// A manual Mock implementation of [PathProviderPlatform] that integrates with Mockito.
/// This satisfies the [PlatformInterface] requirements by using [MockPlatformInterfaceMixin].
class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() => super.noSuchMethod(
    Invocation.method(#getApplicationDocumentsPath, []),
    returnValue: Future<String?>.value(''),
  );

  // PathProviderPlatform requires these overrides even if not used in specific tests
  @override
  Future<String?> getTemporaryPath() => super.noSuchMethod(
    Invocation.method(#getTemporaryPath, []),
    returnValue: Future<String?>.value(''),
  );
  @override
  Future<String?> getApplicationSupportPath() => super.noSuchMethod(
    Invocation.method(#getApplicationSupportPath, []),
    returnValue: Future<String?>.value(''),
  );
  @override
  Future<String?> getLibraryPath() => super.noSuchMethod(
    Invocation.method(#getLibraryPath, []),
    returnValue: Future<String?>.value(''),
  );
  @override
  Future<String?> getExternalStoragePath() => super.noSuchMethod(
    Invocation.method(#getExternalStoragePath, []),
    returnValue: Future<String?>.value(''),
  );
  @override
  Future<List<String>?> getExternalCachePaths() => super.noSuchMethod(
    Invocation.method(#getExternalCachePaths, []),
    returnValue: Future<List<String>?>.value([]),
  );
  @override
  Future<List<String>?> getExternalStoragePaths({StorageDirectory? type}) =>
      super.noSuchMethod(
        Invocation.method(#getExternalStoragePaths, [], {#type: type}),
        returnValue: Future<List<String>?>.value([]),
      );
  @override
  Future<String?> getDownloadsPath() => super.noSuchMethod(
    Invocation.method(#getDownloadsPath, []),
    returnValue: Future<String?>.value(''),
  );
}
