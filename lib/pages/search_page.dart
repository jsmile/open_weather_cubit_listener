import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Form 의 상태를 관리하기 위한 GlobalKey
  final _formKey = GlobalKey<FormState>();
  // 사용자 입력값 저장
  String? _city;
  // Form 의 상태를 관리하기 위한 AutovalidateMode.disabled : 사용자 submit 전까지는 검증하지 않음.
  // 여러번 바뀌므로 final 로 선언하지 않음.
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: Column(
          children: [
            const SizedBox(height: 60.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'City name',
                  hintText: 'more than 2 characters',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                style: const TextStyle(
                  fontSize: 18.0,
                  // color: Color.fromARGB(255, dd227, 226, 226),
                ),
                validator: (String? input) {
                  if (input == null || input.trim().length < 2) {
                    return 'City name must be more than 2 characters';
                  }
                  return null;
                },
                // form submit 시 호출
                onSaved: (String? input) {
                  _city = input;
                },
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _submit,
              child: const Text(
                'How is the weather?',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _submit() {
    // 일단 한 번 submit 했으면 검증하도록 설정.
    setState(
      () {
        _autoValidateMode = AutovalidateMode.always;

        // Form 의 상태가 유효하면 save() 호출
        final form = _formKey.currentState;
        if (form != null && form.validate()) {
          form.save();
          // form.validate() 를 통과했으면 _city 는 null 이 아님므로 ! 를 붙여줌.
          Navigator.pop(context, _city!.trim());
        }
      },
    );
  }
}
