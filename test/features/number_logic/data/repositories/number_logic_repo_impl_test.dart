import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_logic/core/errors/exception.dart';
import 'package:number_logic/core/errors/failures.dart';
import 'package:number_logic/core/network/network_info.dart';
import 'package:number_logic/features/number_logic/data/datasources/number_logic_local_data_source.dart';
import 'package:number_logic/features/number_logic/data/datasources/number_logic_remote_data_source.dart';
import 'package:number_logic/features/number_logic/data/models/number_logic_model.dart';
import 'package:number_logic/features/number_logic/data/repositories/number_logic_repo_impl.dart';
import 'package:number_logic/features/number_logic/domain/entities/number_logic.dart';

class MockRemoteDataSource extends Mock implements NumberLogicRemoteDataSource {
}

class MockLocalDataSource extends Mock implements NumberLogicLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberLogicRepoImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberLogicRepoImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestOnline(Function body) {
    group('device is online', (){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async=> true);
      });
      body();
    });
  }

  void runTestOffLine(Function body) {
    group('device is offline', (){
      setUp((){
        when(mockNetworkInfo.isConnected).thenAnswer((_) async=> false);
      });
      body();
    });
  }

  group('getUserNumberLogic', () {
    final tNumber = 1;
    final tNumberLogicModel =
        NumberLogicModel(text: 'test Logic', number: tNumber);
    final NumberLogic tNumberLogic = tNumberLogicModel;

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getUsersNumbers(tNumber);
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline( () {
      test(
          'should return remote data when the call to remote data source is success ',
          () async {
        when(mockRemoteDataSource.getUsersNumbers(any))
            .thenAnswer((_) async => tNumberLogicModel);
        final result = await repository.getUsersNumbers(tNumber);
        verify(mockRemoteDataSource.getUsersNumbers(tNumber));
        expect(result, equals(Right(tNumberLogic)));
      });

      test(
          'should cache the data locally when the call to remote data source is success ',
          () async {
        when(mockRemoteDataSource.getUsersNumbers(any))
            .thenAnswer((_) async => tNumberLogicModel);
        await repository.getUsersNumbers(tNumber);
        verify(mockRemoteDataSource.getUsersNumbers(tNumber));
        verify(mockLocalDataSource.cacheNumberLogic(tNumberLogicModel));
      });

      test(
          'should return server failure when the call to remote data source is unsuccess ',
          () async {
        when(mockRemoteDataSource.getUsersNumbers(any))
            .thenThrow(ServerException());
        final result = await repository.getUsersNumbers(tNumber);
        verify(mockRemoteDataSource.getUsersNumbers(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestOffLine(() {

      test(
          'should return last locally cached data when the cached data is present',
          () async {
        when(mockLocalDataSource.getLastNumberLogic())
            .thenAnswer((_) async => tNumberLogicModel);
        final result = await repository.getUsersNumbers(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberLogic());
        expect(result, equals(Right(tNumberLogic)));
      });

      test('should return CacheFailure when there is no cached data present',
          () async {
        when(mockLocalDataSource.getLastNumberLogic())
            .thenThrow(CacheException());
        final result = await repository.getUsersNumbers(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberLogic());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberLogic', () {
    final tNumberLogicModel =
    NumberLogicModel(text: 'test Logic', number: 123);
    final NumberLogic tNumberLogic = tNumberLogicModel;

    test('should check if the device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getRandomNumbers();
      verify(mockNetworkInfo.isConnected);
    });

    runTestOnline( () {
      test(
          'should return remote data when the call to remote data source is success ',
              () async {
            when(mockRemoteDataSource.getRandomNumbers())
                .thenAnswer((_) async => tNumberLogicModel);
            final result = await repository.getRandomNumbers();
            verify(mockRemoteDataSource.getRandomNumbers());
            expect(result, equals(Right(tNumberLogic)));
          });

      test(
          'should cache the data locally when the call to remote data source is success ',
              () async {
            when(mockRemoteDataSource.getRandomNumbers())
                .thenAnswer((_) async => tNumberLogicModel);
            await repository.getRandomNumbers();
            verify(mockRemoteDataSource.getRandomNumbers());
            verify(mockLocalDataSource.cacheNumberLogic(tNumberLogicModel));
          });

      test(
          'should return server failure when the call to remote data source is unsuccess ',
              () async {
            when(mockRemoteDataSource.getRandomNumbers())
                .thenThrow(ServerException());
            final result = await repository.getRandomNumbers();
            verify(mockRemoteDataSource.getRandomNumbers());
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          });
    });

    runTestOffLine(() {

      test(
          'should return last locally cached data when the cached data is present',
              () async {
            when(mockLocalDataSource.getLastNumberLogic())
                .thenAnswer((_) async => tNumberLogicModel);
            final result = await repository.getRandomNumbers();
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberLogic());
            expect(result, equals(Right(tNumberLogic)));
          });

      test('should return CacheFailure when there is no cached data present',
              () async {
            when(mockLocalDataSource.getLastNumberLogic())
                .thenThrow(CacheException());
            final result = await repository.getRandomNumbers();
            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberLogic());
            expect(result, equals(Left(CacheFailure())));
          });
    });
  });

}
