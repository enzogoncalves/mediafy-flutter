import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingMedia extends StatelessWidget {
  const LoadingMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.black,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[300]!,
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                height: 55,
                color: Colors.grey[800],
              ),
              
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 192,
                          width: 128,
                          color: Colors.grey[800],
                        ),
              
                        const SizedBox(width: 20,),
              
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 16,
                              width: 200,
                              color: Colors.grey[800],
                            ),
              
                            const SizedBox(height: 10,),
              
                            Container(
                              height: 16,
                              width: 200,
                              color: Colors.grey[800],
                            ),
              
                            const SizedBox(height: 20,),
              
                            Container(
                              height: 30,
                              width: 80,
                              color: Colors.grey[800],
                            ),
                          ],
                        )
                      ],
                    ),
              
                    const SizedBox(height: 20,),
              
                    Container(
                      height: 20,
                      width: 150,
                      color: Colors.grey[800],
                    ),
                    
                    const SizedBox(height: 20,),
              
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 75,
                          color: Colors.grey[800],
                        ),
              
                        const SizedBox(width: 10,),
                        Container(
                          height: 20,
                          width: 75,
                          color: Colors.grey[800],
                        ),
              
                        const SizedBox(width: 10,),
                        Container(
                          height: 20,
                          width: 75,
                          color: Colors.grey[800],
                        ),
              
                        const SizedBox(width: 20,),
              
                        Container(
                          height: 20,
                          width: 50,
                          color: Colors.grey[800],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20,),
              
                    Container(
                      height: 16,
                      width: 250,
                      color: Colors.grey[800],
                    ),
              
                    const SizedBox(height: 20,),
              
                     Container(
                      height: 30,
                      width: 150,
                      color: Colors.grey[800],
                    ),
              
                    const SizedBox(height: 15,),
              
                    Column(
                      children:
                        [1,2,3,4,].map((e) =>  
                          Column(
                            children: [
                              Container(
                                height: 16,
                                width: 300,
                                color: Colors.grey[800],
                              ),
                              const SizedBox(height: 10,)
                            ],
                          ),
                        ).toList()
                    ),
              
                    const SizedBox(height: 15,),
              
                    Column(
                      children:
                        [1,2,3,4,].map((e) =>  
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 18,
                                width: 100,
                                color: Colors.grey[800],
                              ),
                              const SizedBox(height: 10,),
                              Container(
                                height: 16,
                                width: 300,
                                color: Colors.grey[800],
                              ),
                              const SizedBox(height: 20,)
                            ],
                          ),
                        ).toList()
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}