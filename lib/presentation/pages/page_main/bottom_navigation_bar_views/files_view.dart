import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';

final FileManagerController controller = FileManagerController();

class FilesView extends StatefulWidget {
  const FilesView({Key? key}) : super(key: key);

  @override
  State<FilesView> createState() => _FilesViewState();
}

class _FilesViewState extends State<FilesView> {
  @override
  Widget build(BuildContext context) {
    return buildAndroidFilesView();
  }

  Widget buildAndroidFilesView() {
    return FileManager(
      controller: controller,
      builder: (context, snapshot) {
        final List<FileSystemEntity> entities = snapshot;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: entities.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: FileManager.isFile(entities[index])
                    ? const Icon(Icons.feed_outlined)
                    : const Icon(Icons.folder),
                title: Text(FileManager.basename(entities[index])),
                onTap: () {
                  if (FileManager.isDirectory(entities[index])) {
                    controller.openDirectory(entities[index]); // open directory
                  } else {
                    // Perform file-related tasks.
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
