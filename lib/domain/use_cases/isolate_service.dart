import 'dart:isolate';

import 'package:get_it/get_it.dart';
import 'package:neom_commons/core/utils/app_utilities.dart';
import 'package:path_provider/path_provider.dart';

import 'neom_audio_handler.dart';

SendPort? isolateSendPort;

Future<void> startBackgroundProcessing() async {
  AppUtilities.logger.i('Starting Backgroung Proccessing for NeomAudioHandler');

  try {
    final NeomAudioHandler audioHandler = GetIt.I<NeomAudioHandler>();
    final receivePort = ReceivePort();
    await Isolate.spawn(_backgroundProcess, receivePort.sendPort);

    receivePort.listen((message) async {
      if (isolateSendPort == null) {
        AppUtilities.logger.d('IsolateSendPort is Null');
        final appDocumentDirectoryPath = (await getApplicationDocumentsDirectory()).path;
        AppUtilities.logger.i('Setting isolateSendPort with path $appDocumentDirectoryPath');
        isolateSendPort = message as SendPort;
        isolateSendPort?.send(appDocumentDirectoryPath);
      } else {
        AppUtilities.logger.d('IsolateSendPort is not null. Sending refreshLink action with newData: $message');
        await audioHandler.customAction('refreshLink', {'newData': message});
      }
    });
  } catch (e) {
    AppUtilities.logger.e(e.toString());
  }

}

Future<void> _backgroundProcess(SendPort sendPort) async {
  AppUtilities.logger.d('Background Process for SendPort ${sendPort.toString()}');
  final isolateReceivePort = ReceivePort();

  try {
    sendPort.send(isolateReceivePort.sendPort);
    await for (final message in isolateReceivePort) {
      AppUtilities.logger.d('IsolateReceivePort. '
          'Refreshing link for message: ${message.toString()}'
      );
    }
  } catch(e) {
    AppUtilities.logger.e(e.toString());
  }

}
