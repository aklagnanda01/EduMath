import 'package:akla00001/constants/constant.dart';
import 'package:akla00001/extracttext/cropperimage.dart';
import 'package:akla00001/extracttext/extracttext.dart';
import 'package:akla00001/extracttext/selectimage.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  //open ia section
  late final GenerativeModel model ;
  late final ChatSession _chatSession ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GenerativeModel model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: API_OPEN_IA_KEY,
    );
    _chatSession = model.startChat();
  }
  //to check if to active send button or not
  bool isInputText = false;
//active send button or not
  void isText(String? txt) {
    if (txt != null && txt.isNotEmpty) {
      setState(() {
        isInputText = true;
      });
    } else {
      setState(() {
        isInputText = false;
      });
    }
  }

  final ChatUser _currentUser =
      ChatUser(id: "1", firstName: "aklesso", lastName: "Gnanda");
  final ChatUser chatJpt =
      ChatUser(id: "2", firstName: "chat", lastName: "gpt");
  List<ChatMessage> _messages = <ChatMessage>[];
  final _controler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashChat(
        currentUser: _currentUser,
        onSend: (ChatMessage m) {
          getChatresponse(m);
        },
        messages: _messages,
        inputOptions: InputOptions(
          textController: _controler,
          alwaysShowSend: isInputText,
          inputMaxLines: 6,
          leading: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.person,
                  color: primary,
                ))
          ],
          onTextChange: (value) {
            isText(_controler.text);
          },
          trailing: [
            IconButton(
              onPressed: () {
                option(context, _controler);
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        // messageListOptions: MessageListOptions(),
        messageOptions: const MessageOptions(
          currentUserContainerColor: primary,
          containerColor: Color.fromARGB(0, 166, 126, 1),
          textColor: white,
        ),
        // quickReplyOptions: QuickReplyOptions(),
        // scrollToBottomOptions: ScrollToBottomOptions(),
      ),
    );
  }

  Future<void> getChatresponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
    });
    final prompt = 'Write a story about a magic backpack.';
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    for (var element in response!.candidates) {
      if (element.content != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: chatJpt,
              createdAt: DateTime.now(),
              text: element.content.role!,
            ),
          );
        });
      }
    }
  }

  void option(BuildContext context, TextEditingController controler) {
    final size = MediaQuery.of(context).size;
    showMenu(
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(width: 0.5)),
        semanticLabel: "choisir l'option",
        shadowColor: Theme.of(context).primaryColor.withOpacity(0.5),
        constraints: const BoxConstraints(maxWidth: 60, maxHeight: 110),
        context: context,
        position:
            RelativeRect.fromLTRB(size.width * .9, size.height * 0.7, 0, 0),
        items: <PopupMenuEntry>[
          PopupMenuItem(
            value: 1,
            child: const Icon(
              Icons.photo_size_select_actual_outlined,
            ),
            onTap: () async {
              final path = await pickImage(ImageSource.gallery);
              if (!context.mounted) ;
              final cropperPath = await CropperImage(context, path);
              final text = await extract(cropperPath);
              controler.text = text;
              isText(controler.text);
            },
          ),
          const PopupMenuDivider(height: 2),
          PopupMenuItem(
            value: 2,
            child: const Icon(
              Icons.camera_alt_outlined,
            ),
            onTap: () async {
              final path = await pickImage(ImageSource.camera);
              if (!context.mounted) ;
              final cropperPath = await CropperImage(context, path);
              final text = await extract(cropperPath);
              controler.text = text;
              isText(controler.text);
            },
          ),
        ]);
  }
}
