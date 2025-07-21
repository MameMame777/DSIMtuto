# UVM検証手順ガイド - 初心者編 #1

## 🎯 このガイドについて

このドキュメントは、UVM（Universal Verification Methodology）を初めて学ぶ方向けの実践的なガイドです。DSIMtutoプロジェクトを通じて、UVMの基本概念から実際の検証手順まで段階的に学習できます。

## 📚 前提知識

### 必要な知識
- SystemVerilog の基本文法
- テストベンチの基本概念
- AXI4プロトコルの基礎知識（推奨）

### 準備するもの

- DSIM シミュレータ 20240422.0.0 以上
- このDSIMtutoプロジェクト
- テキストエディタ

## 🏗️ UVMとは？

### UVMの基本概念

UVM（Universal Verification Methodology）は、SystemVerilogベースの検証方法論です。

**🤔 なぜUVMが必要？**

従来のテストベンチでは、RTLが複雑になるにつれて以下の問題が発生します：
- コードの再利用が困難
- テストの管理が複雑
- デバッグに時間がかかる
- チーム開発での統一性が低い

**✨ UVMが解決すること：**
- **再利用性**: 一度作ったコンポーネントを他のプロジェクトでも使用可能
- **標準化**: 業界標準の手法で、どのエンジニアでも理解しやすい
- **自動化**: フェーズ管理、設定管理、レポート生成が自動化
- **拡張性**: 小さなテストから大規模な検証環境まで段階的に構築可能

**🏗️ UVMの基本思想：**

```
🎯 「検証も設計」
- テストベンチも設計と同じように体系的に構築
- オブジェクト指向設計によるモジュール化
- 階層構造による責任分離

🔄 「段階的構築」
- 小さなコンポーネントから徐々に大きな環境へ
- 各段階での動作確認とデバッグ
- 必要に応じて機能追加・拡張

📐 「標準化された手法」
- 世界共通のルールと命名規則
- 豊富なライブラリとユーティリティ
- 他の人が作ったコードも理解しやすい
```

**🎮 身近な例で理解：ゲーム開発との類似**

UVMをゲーム開発に例えると：
- **Test**: ゲームのシナリオ（ステージ設計）
- **Environment**: ゲーム世界全体（マップ管理）
- **Agent**: キャラクター（プレイヤー、敵、NPC）
- **Driver**: キャラクターのAI（行動制御）
- **Monitor**: 状況観察者（スコア計算、衝突判定）
- **Sequencer**: イベント管理（タイミング制御）

ゲームでキャラクターが独立して動作しながら、全体として一つのゲームになるように、UVMでも各コンポーネントが独立して動作しながら、全体として一つの検証環境を構成します。

**🔧 DSIMtutoプロジェクトでのUVM活用**

このプロジェクトでは、AXI4 Register Memoryの検証にUVMを使用しています：

```text
実際の検証対象: AXI4 Register Memory IP
├── AXI4インターフェース（1ポート）
├── 4KB メモリ容量
├── 32bit データ幅
└── レジスタマップ機能

UVMによる検証戦略:
├── 🎯 Test: 基本動作、レジスタアクセス、ストレスのテストシナリオ
├── 🏭 Environment: AXI4インターフェース検証環境の管理
├── 🤖 Agent: AXI4プロトコル専用の検証ユニット
├── 🚗 Driver: AXI4プロトコル信号生成
├── 👁️ Monitor: メモリアクセス結果の観測
└── 🏆 Scoreboard: データ整合性チェック
```

**📊 従来手法 vs UVM の比較**

| 観点 | 従来のテストベンチ | UVM検証環境 |
|------|-------------------|-------------|
| **コード量** | 少ない（単純） | 多い（初期構築） |
| **再利用性** | 低い | 高い |
| **保守性** | 困難 | 容易 |
| **デバッグ** | 手動中心 | 自動化支援 |
| **チーム開発** | 個人依存 | 標準化 |
| **学習コスト** | 低い | 高い（初期） |
| **大規模対応** | 困難 | 適している |

**💡 このガイドの学習方針**

1. **理論より実践**: まず動かして、動作を見ながら理解
2. **段階的理解**: 完璧を求めず、少しずつ理解を深める
3. **実例重視**: DSIMtutoの実際のコードを使って学習
4. **エラー活用**: エラーメッセージから学ぶことも重要

```systemverilog
// UVMの基本構造 - 各クラスの役割と責任
class my_test extends uvm_test;           // テスト: 全体の司令塔、何をテストするかを決める
class my_env extends uvm_env;             // 環境: テスト環境全体を管理、複数のエージェントを統括
class my_agent extends uvm_agent;         // エージェント: 特定のインターフェース専用の検証ユニット
class my_driver extends uvm_driver;       // ドライバー: トランザクション→信号変換、RTLに刺激を送る
class my_monitor extends uvm_monitor;     // モニター: 信号→トランザクション変換、RTLの動作を観察
class my_sequencer extends uvm_sequencer; // シーケンサー: トランザクションの流れを制御、交通整理役
```

### UVMの階層構造とデータフロー
```
📊 UVM Component Hierarchy & Data Flow

┌─────────────────────────────────────────────────────────────────┐
│                           🎯 Test                               │
│  ┌─ 何をテストするかを決定、全体の司令塔                         │
│  └─ テストシナリオの定義、成功/失敗の判定                       │
└─────────────────────┬───────────────────────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────────────────────┐
│                        🏭 Environment                          │
│  ┌─ テスト環境全体を統括管理                                   │
│  ├─ 複数エージェントの協調制御                                 │
│  └─ スコアボード、カバレッジ収集                               │
└─────────────────────┬───────────────────────────────────────────┘
                      │
        ┌─────────────▼─────────────┐
        │                           │
┌───────▼─────────┐        ┌───────▼─────────┐
│  🤖 Agent A     │        │  🤖 Agent B     │
│  (AXI Port A)   │        │  (AXI Port B)   │
└─────────────────┘        └─────────────────┘
        │                           │
        ▼                           ▼
┌─────────────────┐        ┌─────────────────┐
│ 📋 Sequencer    │        │ 📋 Sequencer    │
│ ├─ シーケンス管理│        │ ├─ シーケンス管理│
│ └─ 優先度制御   │        │ └─ 優先度制御   │
└─────────┬───────┘        └─────────┬───────┘
          │                          │
          ▼                          ▼
┌─────────────────┐        ┌─────────────────┐
│ 🚗 Driver       │        │ 🚗 Driver       │
│ Transaction     │        │ Transaction     │
│      ↓          │        │      ↓          │
│   Signal        │        │   Signal        │
└─────────┬───────┘        └─────────┬───────┘
          │                          │
          └──────────┐    ┌──────────┘
                     ▼    ▼
              ┌─────────────────┐
              │  🔧 DUT (RTL)   │
              │  AXI2PORT       │
              │     Memory      │
              └─────────┬───────┘
                        │
          ┌─────────────┴─────────────┐
          ▼                           ▼
┌─────────────────┐        ┌─────────────────┐
│ 👁️ Monitor A    │        │ 👁️ Monitor B    │
│   Signal        │        │   Signal        │
│      ↓          │        │      ↓          │
│ Transaction     │        │ Transaction     │
└─────────┬───────┘        └─────────┬───────┘
          │                          │
          └──────────┐    ┌──────────┘
                     ▼    ▼
              ┌─────────────────┐
              │ 🏆 Scoreboard   │
              │ ├─ データ比較   │
              │ ├─ 結果判定     │
              │ └─ レポート生成 │
              └─────────────────┘

🔄 Data Flow Legend:
- 📤 Sequence → Driver: テストパターン送信
- ⚡ Driver → DUT: 信号駆動
- 👀 DUT → Monitor: 結果観測
- 📊 Monitor → Scoreboard: 検証判定
```

### 各コンポーネントの詳細な役割

#### 🎯 **Test（テスト）** - 検証の司令塔
- **役割**: 「何をテストするか」を決定する最上位クラス
- **責任**: 
  - テストシナリオの定義
  - 環境の構築と設定
  - 成功/失敗の最終判定
- **例**: 基本機能テスト、ストレステスト、エラー注入テスト

#### 🏭 **Environment（環境）** - 検証環境の管理者
- **役割**: テスト環境全体を統括管理
- **責任**:
  - 複数のエージェントの協調制御
  - スコアボードによる結果検証
  - カバレッジ収集の統合
- **例**: AXI2PORTでは2つのAXIポートエージェントを管理

#### 🤖 **Agent（エージェント）** - インターフェース専用ユニット
- **役割**: 特定のプロトコル（AXI4等）専用の検証ユニット
- **責任**:
  - ドライバー、モニター、シーケンサーの統合
  - プロトコル固有の設定管理
  - アクティブ/パッシブモードの切り替え
- **例**: AXI4エージェント、APBエージェント、UARTエージェント

#### 🚗 **Driver（ドライバー）** - 信号送信者
- **役割**: 抽象的なトランザクション → 具体的な信号波形に変換
- **責任**:
  - プロトコルに従った信号タイミング生成
  - ハンドシェイク制御
  - RTLへの刺激印加
- **例**: AXI4 Writeトランザクション → AWValid/AWReady信号

#### 👁️ **Monitor（モニター）** - 信号監視者
- **役割**: 信号波形 → 抽象的なトランザクションに変換
- **責任**:
  - プロトコル信号の監視と解析
  - トランザクション復元
  - スコアボードへのデータ送信
- **例**: AXI4信号群 → Readトランザクション情報

#### 📋 **Sequencer（シーケンサー）** - トランザクション制御塔
- **役割**: トランザクションの生成順序と流れを制御
- **責任**:
  - シーケンス（テストパターン）の管理
  - ドライバーとの協調
  - トランザクションの優先度制御
- **例**: 「書き込み→読み出し→比較」の順序制御

## 🚀 Step 1: プロジェクト環境の確認

### 1.0 学習前のチェックリスト

UVMを学習する前に、以下を確認しましょう：

**✅ 環境チェック:**
- [ ] Vivado 2024.2 がインストールされている
- [ ] SystemVerilogの基本文法を理解している
- [ ] テストベンチの概念を知っている
- [ ] コマンドライン操作ができる

**💡 UVM学習のコツ:**
1. **段階的学習**: 一度にすべてを理解しようとしない
2. **実際に動かす**: コードを読むだけでなく、実行して結果を確認
3. **エラーを恐れない**: エラーメッセージから学ぶことが多い
4. **ログを読む習慣**: UVM_INFOメッセージを注意深く読む

**🎯 この章の目標:**
- プロジェクト環境が正しく設定されていることを確認
- UVMライブラリが利用可能であることを確認
- 最初のテスト実行ができる状態にする

### 1.1 環境変数の設定

```cmd
# DSIM環境設定
set "DSIM_LICENSE=%USERPROFILE%\AppData\Local\metrics-ca\dsim-license.json"
call "%USERPROFILE%\AppData\Local\metrics-ca\dsim\20240422.0.0\shell_activate.bat"

# プロジェクト設定
set PROJECT_ROOT=e:\Nautilus\workspace\fpgawork\DSIMtuto
cd %PROJECT_ROOT%
```

### 1.2 プロジェクト構造の確認

```bash
cd %PROJECT_ROOT%
tree verification /F
```

**重要なファイル:**

- `verification/scenarios/axi4_reg_mem_basic_test.sv` - 基本テスト
- `verification/testbench/tb_top.sv` - テストベンチトップ
- `verification/uvm/tests/axi4_base_test.sv` - UVMベーステスト

### 1.4 環境動作確認テスト

設定が完了したら、まず簡単なテストで環境をチェックしましょう：

```cmd
# 1. DSIMコマンド確認
where dsim

# 2. プロジェクトディレクトリに移動
cd %PROJECT_ROOT%\sim\run

# 3. 利用可能なテスト一覧を確認
run.bat

# 4. 基本テスト実行
run.bat axi4_reg_mem_basic

# 5. 結果確認（期待値）
# ✅ "Test completed successfully" が表示される
# ✅ エラーログが空である
# ✅ 波形ファイルが生成される
```

**🚨 よくあるトラブルと解決策:**

#### ❌ "dsim: command not found"

```cmd
# 問題: DSIMのパスが通っていない
# 解決: shell_activate.batを実行
call "%USERPROFILE%\AppData\Local\metrics-ca\dsim\20240422.0.0\shell_activate.bat"
```

#### ❌ "License file not found"

```cmd
# 問題: DSIMライセンスが見つからない
# 解決: ライセンス環境変数を設定
set "DSIM_LICENSE=%USERPROFILE%\AppData\Local\metrics-ca\dsim-license.json"
```

#### ❌ "Permission denied" エラー

```cmd
# 問題: ファイルアクセス権限
# 解決: 管理者権限でコマンドプロンプトを開く
# または、ユーザーディレクトリにプロジェクトをコピー
```

## 🔍 Step 2: UVMの実行フローを理解しよう

### 2.1 UVMフェーズとは？

UVMには「フェーズ」という概念があります。これは、テストの実行を段階的に制御するメカニズムです。

```systemverilog
// UVMの主要フェーズ
class my_component extends uvm_component;
    function void build_phase(uvm_phase phase);     // 構築フェーズ
    function void connect_phase(uvm_phase phase);   // 接続フェーズ
    function void end_of_elaboration_phase(...);    // 詳細化完了フェーズ
    function void start_of_simulation_phase(...);   // シミュレーション開始フェーズ
    task run_phase(uvm_phase phase);                // 実行フェーズ
    function void extract_phase(uvm_phase phase);   // 抽出フェーズ
    function void check_phase(uvm_phase phase);     // チェックフェーズ
    function void report_phase(uvm_phase phase);    // レポートフェーズ
endclass
```

### 2.2 フェーズの実行順序

UVMは以下の順序でフェーズを実行します：

```
📋 Phase Flow - UVM実行フロー
╔══════════════════════════════════════════════════════════════════════╗
║                        UVM PHASE EXECUTION FLOW                     ║
╠══════════════════════════════════════════════════════════════════════╣
║                                                                      ║
║  🏗️  build_phase           ← コンポーネント作成                      ║
║      ├─ create components                                            ║
║      ├─ set configuration                                            ║
║      └─ build hierarchy                                              ║
║                                                                      ║
║  🔗  connect_phase          ← ポート接続                             ║
║      ├─ connect TLM ports                                            ║
║      ├─ get virtual interfaces                                       ║
║      └─ establish communication                                      ║
║                                                                      ║
║  ✅  end_of_elaboration     ← 構造確定                               ║
║      └─ finalize configuration                                       ║
║                                                                      ║
║  🎬  start_of_simulation    ← シミュレーション準備                    ║
║      └─ display banner information                                   ║
║                                                                      ║
║  ⚡  run_phase             ← メイン実行（並行実行）                   ║
║      ├─ reset_phase                                                  ║
║      ├─ configure_phase                                              ║
║      ├─ main_phase         ← ⭐ テストのメイン処理                    ║
║      └─ shutdown_phase                                               ║
║                                                                      ║
║  📊  extract_phase         ← 結果抽出                                ║
║      └─ collect coverage & results                                   ║
║                                                                      ║
║  ✔️  check_phase           ← 結果チェック                            ║
║      └─ verify test results                                          ║
║                                                                      ║
║  📋  report_phase          ← レポート生成                            ║
║      └─ generate final report                                        ║
║                                                                      ║
╚══════════════════════════════════════════════════════════════════════╝
```

### 2.3 各フェーズの詳細

#### **build_phase** - 「建設」フェーズ
コンポーネントを作成し、設定を行います。

```systemverilog
// 例：テストクラスでの build_phase
function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // 環境を作成
    env = axi2port_env::type_id::create("env", this);
    
    // 設定をconfig DBに登録
    uvm_config_db#(int)::set(this, "env.agent_a", "is_active", UVM_ACTIVE);
    
    `uvm_info("BUILD", "Test environment created", UVM_LOW)
endfunction
```

**このフェーズでやること:**
- コンポーネントのインスタンス化（`create()`）
- 設定値の登録（`uvm_config_db::set()`）
- 階層構造の構築

#### **connect_phase** - 「接続」フェーズ
コンポーネント間の接続を行います。

```systemverilog
// 例：環境クラスでの connect_phase
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // エージェントのモニターをスコアボードに接続
    agent_a.ap.connect(scoreboard.analysis_imp_a);
    agent_b.ap.connect(scoreboard.analysis_imp_b);
    
    `uvm_info("CONNECT", "All components connected", UVM_LOW)
endfunction
```

**このフェーズでやること:**
- Analysis portの接続
- TLM FIFOの接続
- インターフェースの取得（`uvm_config_db::get()`）

#### **run_phase** - 「実行」フェーズ
メインのテスト処理を実行します。

```systemverilog
// 例：テストクラスでの run_phase
task run_phase(uvm_phase phase);
    axi4_write_read_seq seq;
    
    // フェーズのobjection設定（重要！）
    phase.raise_objection(this, "Starting main test");
    
    `uvm_info("RUN", "Starting test sequence", UVM_LOW)
    
    // メインのテスト処理
    seq = axi4_write_read_seq::type_id::create("seq");
    seq.start(env.agent_a.sequencer);
    
    // 終了前に少し待機
    #1000ns;
    
    // フェーズのobjection解除（重要！）
    phase.drop_objection(this, "Test completed");
    
    `uvm_info("RUN", "Test sequence completed", UVM_LOW)
endtask
```

**このフェーズでやること:**
- シーケンスの実行
- データの送受信
- 結果の収集

#### **objection**メカニズム

run_phaseでは**objection**という仕組みを使って、テストの実行時間を制御します。

```systemverilog
task run_phase(uvm_phase phase);
    // ⭐ objectionを上げる = 「まだ実行中です」と宣言
    phase.raise_objection(this, "Starting test");
    
    // テスト処理
    run_test_sequences();
    
    // ⭐ objectionを下げる = 「実行完了しました」と宣言
    phase.drop_objection(this, "Test finished");
endtask
```

**重要ポイント:**
- `raise_objection()`: フェーズを継続させる
- `drop_objection()`: フェーズ終了を許可
- 全コンポーネントがobjectionを下げると、フェーズが終了

### 2.5 実際のログでフェーズを確認

AXI2PORTプロジェクトを実行すると、フェーズの実行ログが表示されます：

```log
# UVM実行ログの例（sim/results/axi2port_basic_test_nodpi.log より）

UVM_INFO @ 0: reporter [RNTST] Running test axi2port_basic_test_nodpi...

# BUILD PHASE - コンポーネント構築
UVM_INFO @ 0: testbench.env [BUILD] Environment created successfully
UVM_INFO @ 0: testbench.env.agent_a [BUILD] AXI4 Agent A created
UVM_INFO @ 0: testbench.env.agent_b [BUILD] AXI4 Agent B created

# CONNECT PHASE - 接続処理
UVM_INFO @ 0: testbench.env [CONNECT] All agents connected to scoreboard
UVM_INFO @ 0: testbench.env.agent_a [CONNECT] Virtual interface configured

# END_OF_ELABORATION PHASE
UVM_INFO @ 0: testbench.env [END_ELAB] Elaboration completed

# START_OF_SIMULATION PHASE
UVM_INFO @ 0: testbench.env [START_SIM] Simulation starting...

# RUN PHASE - メインテスト実行
UVM_INFO @ 10ns: testbench.env.agent_a.sequencer [RUN] Running basic test sequence
UVM_INFO @ 50ns: testbench.env.scoreboard [CHECK] Write transaction received
UVM_INFO @ 80ns: testbench.env.scoreboard [CHECK] Read transaction verified

# 実行完了
UVM_INFO @ 1000ns: testbench [REPORT] Test completed successfully
*** TEST PASSED ***
```

**フェーズごとの処理時間**:
- build/connect/elaboration: ~0ns (即時)
- run_phase: 10ns～1000ns (テスト時間)
- extract/check/report: 1000ns以降

**ポイント**:
- 各フェーズで異なる `UVM_INFO` メッセージが出力される
- `objection` が正しく管理されていると `TEST PASSED` となる
- エラーがあると該当フェーズで `UVM_ERROR` が出力される

### 2.6 フェーズでよくあるエラーとデバッグ

#### ❌ build_phase エラー
```log
UVM_FATAL @ 0: testbench.env.agent_a [BUILD] Cannot get virtual interface from config DB
```
**原因**: virtual interfaceの設定ミス  
**解決**: `uvm_config_db::set()` でinterfaceを正しく設定

#### ❌ run_phase でハング
```log
UVM_INFO @ 10ns: testbench [RUN] Starting test...
# ここで停止してしまう
```
**原因**: `drop_objection()` の呼び忘れ  
**解決**: `raise_objection()` と `drop_objection()` をペアで記述

#### ❌ テスト終了しない
```log
UVM_INFO @ 1000000ns: testbench [RUN] Still running...
```
**原因**: objectionが残っている  
**解決**: 全コンポーネントで objection の対応確認

AXI2PORTプロジェクトの実際のコードを見てみましょう：

```systemverilog
// verification/scenarios/axi4_reg_mem_basic_test.sv から抜粋
class Axi4_Reg_Mem_Basic_Test extends uvm_test;
    
    // 1. build_phase: 環境構築
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // virtual interfaceの取得
        if (!uvm_config_db#(virtual axi4_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Virtual interface not found in config database")
        end
    endfunction
    
    // 2. run_phase: テスト実行
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        
        // 基本テストシーケンス実行
        run_basic_test_sequence();
        
        phase.drop_objection(this);
    endtask
    
    // 3. カスタムテスト処理
    task run_basic_test_sequence();
        // 実際のテストロジック
        test_reset_behavior();
        test_basic_write();
        test_basic_read();
        test_write_read_verify();
    endtask
endclass
```

## 🧪 Step 3: UVMコンポーネントを理解しよう

### 3.1 Transaction（トランザクション）
データを運ぶ「荷物」のようなもの

```systemverilog
// verification/scenarios/axi4_transaction.sv
class axi4_transaction extends uvm_sequence_item;
    rand logic [31:0] addr;     // アドレス
    rand logic [31:0] data;     // データ
    rand logic [3:0]  strb;     // ストローブ
    
    `uvm_object_utils_begin(axi4_transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(strb, UVM_ALL_ON)
    `uvm_object_utils_end
endclass
```

**理解ポイント:**
- `rand`: ランダム値を生成
- `uvm_object_utils`: UVMマクロで自動機能生成
- `uvm_field_*`: フィールドの自動処理

### 3.2 Sequence（シーケンス）
トランザクションを生成する「工場」

```systemverilog
// verification/uvm/sequences/axi4_sequences.sv から抜粋
class axi4_write_seq extends uvm_sequence #(axi4_transaction);
    `uvm_object_utils(axi4_write_seq)
    
    task body();
        axi4_transaction req;
        
        // トランザクション生成
        req = axi4_transaction::type_id::create("req");
        
        // ランダム化
        assert(req.randomize() with {
            addr inside {[0:'h3FF]};  // アドレス範囲制限
            strb == 4'b1111;          // 全バイト有効
        });
        
        // 送信
        start_item(req);
        finish_item(req);
    endtask
endclass
```

**理解ポイント:**
- `body()`: シーケンスのメイン処理
- `start_item()`, `finish_item()`: トランザクション送信
- `randomize() with`: 制約付きランダム化

### 3.3 Driver（ドライバー）
トランザクションを信号に変換する「翻訳者」

```systemverilog
// verification/uvm/agents/axi4_driver.sv から抜粋
class axi4_driver extends uvm_driver #(axi4_transaction);
    virtual axi4_if axi_if;  // インターフェース
    
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);  // トランザクション取得
            drive_transaction(req);            // 信号駆動
            seq_item_port.item_done();         // 完了通知
        end
    endtask
    
    task drive_transaction(axi4_transaction req);
        // AXI4プロトコルに従って信号を駆動
        @(posedge axi_if.aclk);
        axi_if.awvalid <= 1'b1;
        axi_if.awaddr  <= req.addr;
        // ... その他の信号設定
    endtask
endclass
```

**理解ポイント:**
- `virtual interface`: RTLとの接続点
- `get_next_item()`: シーケンサーからトランザクション取得
- `run_phase()`: 常時実行されるメイン処理

### 3.4 Monitor（モニター）
信号を監視してトランザクションに変換する「観察者」

```systemverilog
// verification/uvm/agents/axi4_monitor.sv から抜粋
class axi4_monitor extends uvm_monitor;
    virtual axi4_if axi_if;
    uvm_analysis_port #(axi4_transaction) ap;
    
    task run_phase(uvm_phase phase);
        forever begin
            wait_for_transaction();     // トランザクション待機
            collect_transaction();      // データ収集
            ap.write(collected_trans);  // 結果送信
        end
    endtask
    
    task collect_transaction();
        // AXI4信号からトランザクション復元
        wait(axi_if.awvalid && axi_if.awready);
        collected_trans.addr = axi_if.awaddr;
        collected_trans.data = axi_if.wdata;
        // ...
    endtask
endclass
```

**理解ポイント:**
- `uvm_analysis_port`: データ配信用ポート
- `wait()`: 信号待機
- 信号→トランザクション変換

## 🧪 Step 4: 実際のテストを読んでみよう

### 4.1 基本テストの構造

`verification/scenarios/axi4_reg_mem_basic_test.sv`を開いてみましょう。

```systemverilog
class Axi4_Reg_Mem_Basic_Test extends uvm_test;
    `uvm_component_utils(Axi4_Reg_Mem_Basic_Test)
    
    // 1. 仮想インターフェースのインスタンス
    virtual axi4_if vif;
    
    // 2. 初期化処理
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual axi4_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal(get_type_name(), "Virtual interface not found in config database")
        end
    endfunction
    
    // 3. メインテスト処理
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        run_basic_test_sequence();
        phase.drop_objection(this);
    endtask
endclass
```

**読み方のポイント:**

1. **継承**: `extends uvm_test`でUVMテストクラスを継承
2. **マクロ**: `uvm_component_utils`で自動機能生成
3. **フェーズ**: `build_phase`, `run_phase`でタイミング制御

### 4.2 テストシーケンスの読み方
```systemverilog
task run_basic_sequence();
    axi4_write_read_seq seq;
    
    // 1. シーケンス生成
    seq = axi4_write_read_seq::type_id::create("seq");
    
    // 2. 制約設定
    assert(seq.randomize() with {
        addr == 'h100;
        data == 'hDEADBEEF;
    });
    
    // 3. 実行
    seq.start(env.agent_a.sequencer);
endtask
```

**実行の流れ:**
1. シーケンス生成 → トランザクション作成
2. ドライバーが信号駆動 → RTLに入力
3. モニターが結果監視 → 検証判定

## 🏃‍♂️ Step 4: 実際にテストを実行してみよう

### 4.1 基本テストの実行

```bash
# プロジェクトディレクトリに移動
cd %PROJECT_ROOT%\sim\run

# 基本テスト実行
run.bat axi4_reg_mem_basic
```

### 4.2 実行結果の見方

```log
# 成功例
UVM_INFO @ 0: reporter [RNTST] Running test Axi4_Reg_Mem_Basic_Test...
UVM_INFO @ 100ns: testbench [DRIVER] Starting write transaction
UVM_INFO @ 200ns: testbench [MONITOR] Write completed
UVM_INFO @ 300ns: testbench [CHECK] Data match: PASS

# 最終結果
UVM_INFO :   25  ← メッセージ数
UVM_WARNING : 0  ← 警告数  
UVM_ERROR :   0  ← エラー数（0であることが重要！）
UVM_FATAL :   0  ← 致命的エラー数
```

**判定基準:**

- ✅ **成功**: UVM_ERROR = 0, UVM_FATAL = 0
- ❌ **失敗**: UVM_ERROR > 0 または UVM_FATAL > 0

### 4.3 波形の確認

```bash
# 波形ファイルを開く（DSIMビューアーで）
# または波形ファイルが.vcd形式の場合、GtkWaveなどで開く
```

**チェックポイント:**

- クロック信号が正常に動作している
- AXI4ハンドシェイク（valid/ready）が正しい
- データがメモリに正しく書き込まれている

## 🔧 Step 5: 簡単なテストを作ってみよう

### 5.0 テスト作成の流れ

UVMでテストを作成する基本的な流れ：

```
1️⃣ 要件定義     : 何をテストしたいかを明確にする
2️⃣ シーケンス設計 : どんなデータパターンを送るか
3️⃣ テスト実装   : コードとして実装
4️⃣ 実行と検証   : 動作確認とデバッグ
5️⃣ 改良        : より良いテストに改善
```

**💡 今回の例: 連続アドレステスト**
- **目的**: メモリの連続アドレスに書き込み→読み出し
- **パターン**: 0x00, 0x04, 0x08 に順番にデータ書き込み
- **検証**: 書き込んだデータが正しく読み出せるか

### 5.1 新しいシーケンスを作成

まず、シーケンスファイルを作成します：

**📁 ファイル:** `verification/uvm/sequences/my_first_sequence.sv`

```systemverilog
// my_first_sequence.sv
class my_first_sequence extends axi4_base_seq;
    `uvm_object_utils(my_first_sequence)
    
    function new(string name = "my_first_sequence");
        super.new(name);
    endfunction
    
    task body();
        axi4_transaction req;
        
        `uvm_info("MY_SEQ", "Starting my first sequence!", UVM_LOW)
        
        // 3回書き込みテスト
        for (int i = 0; i < 3; i++) begin
            req = axi4_transaction::type_id::create("req");
            
            assert(req.randomize() with {
                addr == (i * 4);           // 0x00, 0x04, 0x08
                data == ('hA000 + i);      // 0xA000, 0xA001, 0xA002
                strb == 4'b1111;
            });
            
            start_item(req);
            finish_item(req);
            
            `uvm_info("MY_SEQ", $sformatf("Write %0d: addr=0x%04x, data=0x%08x", 
                     i, req.addr, req.data), UVM_LOW)
        end
        
        `uvm_info("MY_SEQ", "Sequence completed!", UVM_LOW)
    endtask
endclass
```

### 5.2 新しいテストクラスを作成
```systemverilog
// my_first_test.sv
class my_first_test extends axi2port_base_test_nodpi;
    `uvm_component_utils(my_first_test)
    
    function new(string name = "my_first_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    task run_phase(uvm_phase phase);
        my_first_sequence seq;
        
        `uvm_info("MY_TEST", "Starting my first test!", UVM_LOW)
        
        // フェーズを延長（テスト実行のため）
        phase.raise_objection(this);
        
        // シーケンス実行
        seq = my_first_sequence::type_id::create("seq");
        seq.start(env.agent_a.sequencer);
        
        // 少し待機
        #1000ns;
        
        // フェーズ終了
        phase.drop_objection(this);
        
        `uvm_info("MY_TEST", "Test completed!", UVM_LOW)
    endtask
endclass
```

### 5.3 テスト実行のためのファイル修正
既存のテストファイルに新しいテストを追加するか、新しいTclスクリプトを作成してテストを実行します。

## 📊 Step 6: デバッグとトラブルシューティング

### 6.1 よくあるエラーと対処法

#### エラー1: UVM_ERROR - Interface not found
```log
UVM_ERROR: Failed to get axi_a_vif from config DB
```

**原因**: インターフェースがconfig DBに登録されていない

**対処法**:
```systemverilog
// テストベンチで設定を確認
uvm_config_db#(virtual axi4_if)::set(null, "*", "axi_a_vif", axi_a_if);
```

#### エラー2: Compilation Error - DPI関連
```log
ERROR: DPI symbol not found
```

**対処法**: UVM_NO_DPIを使用
```systemverilog
`define UVM_NO_DPI
```

#### エラー3: Simulation hangs
**原因**: フェーズのobjection管理不備

**対処法**:
```systemverilog
task run_phase(uvm_phase phase);
    phase.raise_objection(this);  // 忘れずに！
    // テスト処理
    phase.drop_objection(this);   // 忘れずに！
endtask
```

### 6.2 デバッグのコツ

#### UVM_INFOメッセージを活用
```systemverilog
`uvm_info("DEBUG", $sformatf("addr=0x%x, data=0x%x", addr, data), UVM_LOW)
```

#### 段階的にテストを簡素化
1. 最小限のテストから開始
2. 1つずつ機能を追加
3. 各段階で動作確認

#### 波形とログの併用
- 波形: タイミングの確認
- ログ: データ値の確認

## 🎓 まとめ

### 📚 学習したこと

このガイドで学習した内容：

1. **UVMの基本構造**: Test → Env → Agent → Driver/Monitor/Sequencer の階層関係
2. **UVMフェーズ**: build → connect → run → check → report の実行順序
3. **objectionメカニズム**: テスト実行時間の制御方法
4. **コンポーネントの役割**: 各クラスが何をするのか
5. **実際のコード読解**: DSIMtutoプロジェクトでの実装例
6. **テスト作成**: 新しいシーケンスとテストの実装方法
7. **デバッグ技術**: エラーの見方と対処法

### ✅ 理解度チェック

以下の質問に答えられるか確認してみましょう：

**🔍 基本概念:**

- [ ] UVMの5つの主要コンポーネントを説明できる
- [ ] フェーズの実行順序を覚えている
- [ ] objectionの役割を理解している

**💻 実践的理解:**

- [ ] 基本テストを実行できる
- [ ] ログからテスト成否を判断できる
- [ ] 簡単なシーケンスを作成できる

**🐛 トラブルシューティング:**

- [ ] よくあるエラーパターンを知っている
- [ ] 環境設定問題を解決できる
- [ ] 波形とログを併用してデバッグできる

**🎯 到達目標:**

- [ ] DSIMtutoプロジェクトのテストを理解し、実行できる
- [ ] 自分でシンプルなテストを作成できる
- [ ] UVMの次の学習ステップが分かる

### 🚀 次のステップ

**レベル別学習パス:**

**🥇 初級者（このガイドを完了）**
- **#2 検証計画編**: テストプランの作成方法
- **#3 シーケンス応用編**: より高度なテストパターン

**🥈 中級者（基本操作に慣れた）**
- **#4 カバレッジ編**: カバレッジ駆動検証
- **#5 制約ランダム編**: SystemVerilogの制約機能活用

**🥉 上級者（UVMに習熟）**
- **#6 パフォーマンス編**: 大規模テスト環境の構築
- **#7 カスタムコンポーネント編**: 独自コンポーネントの開発

### 参考資料

- [UVM実行フロー](uvm_execution_flow.md) - より詳細なUVM実行手順
- [UVMガイド](uvm_guide.md) - UVMメソドロジの詳細
- [AXI4仕様](axi4_spec.md) - AXI4プロトコルの詳細

---

**🎉 お疲れ様でした！**

UVMの第一歩を踏み出しました。わからないことがあれば、実際にコードを動かしながら学習を進めてください。実践が一番の理解への近道です！
