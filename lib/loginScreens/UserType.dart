import 'package:flutter/material.dart';
import 'ManagerLogin.dart';  // Yeni yönetici sayfası

import 'ResidentLogin.dart';  // Yeni bina sakini sayfası

class UserType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kullanıcı Tipi Seçin')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManagerLogin()), // Yeni sınıfı çağırıyoruz
                );
              },
              child: Text('Yönetici'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResidentLogin()), // Yeni sınıfı çağırıyoruz
                );
              },
              child: Text('Bina Sakini'),
            ),
          ],
        ),
      ),
    );
  }
}
