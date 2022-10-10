import 'package:flutter/material.dart';
import 'GridButton.dart';

class Grid extends StatelessWidget {
  var numbers = [];
  var size;
  Function clickGrid;

  Grid(this.numbers, this.size, this.clickGrid);

  @override
  Widget build(BuildContext context) {
    var height = size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
        ),
        itemCount: numbers.length,
        itemBuilder: (context, index) {
          return numbers[index] != 0
              ? GridButton("${numbers[index]}", () {
                  clickGrid(index);
                })
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
