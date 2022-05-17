## 介绍构建 profiles

Apache Maven 竭尽全力确保构建是可移植的。除其他外，这意味着允许在 POM 中进行构建配置，避免**所有**文件系统引用（在继承、依赖项和其他地方），并更加依赖本地存储库来存储实现这一点所需的元数据。

然而，有时可移植性并非完全可行。在某些情况下，插件可能需要配置本地文件系统路径。在其他情况下，将需要稍微不同的依赖集，并且项目的工件名称可能需要稍微调整。在其他时候，您甚至可能需要在构建生命周期中包含整个插件，具体取决于检测到的构建环境。

为了解决这些情况，Maven 支持构建配置文件。配置文件是使用 POM 本身中可用元素的子集（加上一个额外的部分）指定的，并以多种方式中的任何一种触发。它们在构建时修改 POM，旨在用于互补集，为一组目标环境提供等效但不同的参数（例如，在开发、测试和生产环境）。因此，配置文件很容易导致团队中不同成员的不同构建结果。但是，如果使用得当，可以使用配置文件，同时仍然保持项目的可移植性。这也将最大限度地减少使用`-f`maven 的选项，它允许用户创建另一个具有不同参数或配置的 POM 来构建，这使得它更易于维护，因为它仅使用一个 POM 运行。

### 有哪些不同类型的配置文件？每个定义在哪里？

- 每个项目
  
  - 在 POM 本身中定义`(pom.xml)`。

- 每个用户
  
  - 在[Maven-settings](https://maven.apache.org/ref/current/maven-settings/settings.html) `(%USER_HOME%/.m2/settings.xml)`中定义。

- 全球的
  
  - 在[全局 Maven-settings](https://maven.apache.org/ref/current/maven-settings/settings.html) `(${maven.home}/conf/settings.xml)`中定义。

- 配置文件描述符
  
  - 位于[项目 basedir`(profiles.xml)`](https://maven.apache.org/ref/2.2.1/maven-profile/profiles.html)中的描述符（Maven 3.0 及更高版本不再支持；请参阅[Maven 3 兼容性说明](https://cwiki.apache.org/confluence/display/MAVEN/Maven+3.x+Compatibility+Notes#Maven3.xCompatibilityNotes-profiles.xml)）

### 如何触发配置文件？这如何根据所使用的配置文件类型而变化？

可以通过多种方式激活配置文件：

- 从命令行
- 通过 Maven 设置
- 基于环境变量
- 操作系统设置
- 存在或丢失文件

#### 有关个人资料激活的详细信息

可以使用`-P`命令行标志显式指定配置文件。

此标志后跟要使用的配置文件 ID 的逗号分隔列表。选项中指定的配置文件除了通过其激活配置或`<activeProfiles>`. `settings.xml`从 Maven 4 开始，Maven 将拒绝激活或停用无法解析的配置文件。为防止这种情况，请在配置文件标识符前加上`?`，将其标记为可选：



可以在 Maven 设置中通过该`<activeProfiles>`部分激活配置文件。本节采用一个`<activeProfile>`元素列表，每个元素都包含一个 profile-id。



`<activeProfiles>`每次项目使用时，默认情况下都会激活标签中列出的配置文件。

可以根据检测到的构建环境状态自动触发配置文件。这些触发器是通过`<activation>`配置文件本身的一个部分指定的。目前，此检测仅限于 JDK 版本的前缀匹配、系统属性的存在或系统属性的值。这里有些例子。

以下配置将在 JDK 的版本以“1.4”开头时触发配置文件（例如“1.4.0_08”、“1.4.2_07”、“1.4”）：





从 Maven 2.1 开始也可以使用范围（有关更多信息，请参阅[Enforcer 版本范围语法](https://maven.apache.org/enforcer/enforcer-rules/versionRanges.html)）。以下荣誉版本 1.3、1.4 和 1.5。



*注意：*上限`,1.5]`可能不包括 1.5 的大多数版本，因为它们将有一个额外的“补丁”版本，例如`_05`上述范围内未考虑的版本。

下一个将根据操作系统设置激活。有关操作系统值的更多详细信息，请参阅[Maven Enforcer 插件](https://maven.apache.org/enforcer/enforcer-rules/requireOS.html)。



当系统属性“debug”被指定为任何值时，下面的配置文件将被激活：



当系统属性“调试”根本没有定义时，将激活以下配置文件：



当未定义系统属性“debug”或使用非“true”值定义时，将激活以下配置文件。



要激活它，您可以在命令行上键入其中一个：



下一个示例将在使用值“test”指定系统属性“environment”时触发配置文件：



要激活它，您可以在命令行上键入：



从 Maven 3.0 开始，POM 中的配置文件也可以根据来自`settings.xml`.

**注意**： 环境变量之类`FOO`的可用作表单的属性`env.FOO`。进一步注意，环境变量名称在 Windows 上被规范化为全部大写。

此示例将在生成的文件`target/generated-sources/axistools/wsdl2java/org/apache/maven`丢失时触发配置文件。



从 Maven 2.0.9 开始，可以对标签`<exists>`和`<missing>`进行插值。支持的变量是系统属性`${user.home}`和环境变量，如`${env.HOME}`. 请注意，POM 本身中定义的属性和值在这里不能用于插值，例如上面的示例激活器不能使用`${project.build.directory}`但需要硬编码路径`target`。

默认情况下，配置文件也可以使用如下配置处于活动状态：



除非使用上述方法之一激活同一 POM 中的另一个配置文件，否则此配置文件将自动对所有构建处于活动状态。当在命令行或通过其激活配置激活 POM 中的配置文件时，默认情况下处于活动状态的所有配置文件都会自动停用。

#### 停用配置文件

从 Maven 2.0.10 开始，可以使用命令行禁用一个或多个配置文件，方法是在其标识符前加上字符“！” 或 '-' 如下图所示：



或者



这可用于停用标记为 activeByDefault 的配置文件或将通过其激活配置激活的配置文件。

### 每种类型的配置文件可以自定义 POM 的哪些区域？为什么？[](https://maven.apache.org/guides/introduction/introduction-to-profiles.html#which-areas-of-a-pom-can-be-customized-by-each-type-of-profile-w)

既然我们已经讨论了在何处指定配置文件以及如何激活它们，那么讨论您可以在配置文件中指定的内容将会很有*用*。与配置文件配置的其他方面一样，这个答案并不简单。

根据您选择配置配置文件的位置，您将可以访问不同的 POM 配置选项。

#### 外部文件中的配置文件[](https://maven.apache.org/guides/introduction/introduction-to-profiles.html#profiles-in-external-files)

在外部文件（即 in`settings.xml`或`profiles.xml`）中指定的配置文件在最严格的意义上是不可移植的。任何似乎很有可能改变构建结果的东西都仅限于 POM 中的内联配置文件。诸如存储库列表之类的东西可能只是已批准工件的专有存储库，并且不会改变构建的结果。因此，您将只能修改`<repositories>`and`<pluginRepositories>`部分，以及一个额外的`<properties>`部分。

该`<properties>`部分允许您指定自由格式的键值对，这些键值对将包含在 POM 的插值过程中。这允许您以`${profile.provided.path}`.

#### POM 中的配置文件[](https://maven.apache.org/guides/introduction/introduction-to-profiles.html#profiles-in-poms)

另一方面，如果您的配置文件可以在 POM 中合理地指定*，*那么您有更多的选择。当然，权衡是您只能修改*该*项目及其子模块。由于这些配置文件是内联指定的，因此有更好的机会保留可移植性，因此可以合理地说您可以向它们添加更多信息，而不会有其他用户无法使用该信息的风险。

POM 中指定的配置文件可以修改[以下 POM 元素](https://maven.apache.org/ref/current/maven-model/maven.html)：

- `<repositories>`
- `<pluginRepositories>`
- `<dependencies>`
- `<plugins>`
- `<properties>`（实际上在主 POM 中不可用，但在幕后使用）
- `<modules>`
- `<reports>`
- `<reporting>`
- `<dependencyManagement>`
- `<distributionManagement>`
- 元素的子集`<build>`，包括：
  - `<defaultGoal>`
  - `<resources>`
  - `<testResources>`
  - `<directory>`
  - `<finalName>`
  - `<filters>`
  - `<pluginManagement>`
  - `<plugins>`

#### <profiles> 之外的 POM 元素[](https://maven.apache.org/guides/introduction/introduction-to-profiles.html#pom-elements-outside-profiles)

我们不允许在 POM 配置文件之外修改某些 POM 元素，因为这些运行时修改不会在 POM 部署到存储库系统时分发，从而使该人对该项目的构建与其他人完全不同。虽然您可以通过为外部配置文件提供的选项在某种程度上做到这一点，但危险是有限的。另一个原因是有时会从父 POM 重用此 POM 信息。

外部文件，例如`settings.xml`也不`profiles.xml`支持 POM 配置文件之外的元素。让我们以这个场景进行详细说明。当有效的 POM 部署到远程存储库时，任何人都可以从存储库中获取其信息并使用它直接构建 Maven 项目。现在，想象一下，如果我们可以在依赖项中设置配置文件，这对构建非常重要，或者在 POM 配置文件之外的任何其他元素中设置，`settings.xml`那么很可能我们不能期望其他人使用存储库中的 POM 并能够构建它。我们还必须考虑如何分享`settings.xml`和其他人。请注意，要配置的文件过多会非常混乱且难以维护。底线是，由于这是构建数据，它应该在 POM 中。Maven 2 的目标之一是将运行构建所需的所有信息整合到单个文件或文件层次结构中，即 POM。

### 配置文件订单[](https://maven.apache.org/guides/introduction/introduction-to-profiles.html#profile-order)

来自活动配置文件的 POM 中的所有配置文件元素都会覆盖与 POM 具有相同名称的全局元素，或者在集合的情况下扩展这些元素。如果多个配置文件在同一个 POM 或外部文件中处于活动状态，则**稍后**定义的那些优先于**之前**定义的那些（与其配置文件 ID 和激活顺序无关）。

例子：



这导致存储库列表：`profile-2-repo, profile-1-repo, global-repo`.

### 个人资料陷阱[](https://maven.apache.org/guides/introduction/introduction-to-profiles.html#profile-pitfalls)

我们已经提到，将配置文件添加到构建中可能会破坏项目的可移植性。我们甚至强调了配置文件可能会破坏项目可移植性的情况。但是，作为更连贯的讨论的一部分，有必要重申这些观点，以便在使用配置文件时避免一些陷阱。

使用配置文件时需要牢记两个主要问题领域。首先是外部属性，通常用于插件配置。这些构成破坏项目可移植性的风险。另一个更微妙的领域是对一组自然配置文件的不完整规范。

#### 外部属性[](https://maven.apache.org/guides/introduction/introduction-to-profiles.html#external-properties)

外部属性定义涉及在外部定义`pom.xml`但未在其内部的相应配置文件中定义的任何属性值。POM 中属性最明显的用法是在插件配置中。虽然没有属性当然有可能破坏项目的可移植性，但这些生物可能会产生微妙的影响，导致构建失败。例如，`settings.xml`当团队中的其他用户尝试在没有类似`settings.xml`. 考虑以下`pom.xml`Web 应用程序项目的代码片段：



现在，在您的本地`${user.home}/.m2/settings.xml`，您有：



当您构建**集成测试**生命周期阶段时，您的集成测试通过，因为您提供的路径允许测试插件安装和测试此 Web 应用程序。

*但是*，当您的同事尝试构建**集成测试**时，他的构建失败了，抱怨它无法解析插件配置参数`<appserverHome>`，或者更糟糕的是，该参数的值 - 从字面上看`${appserver.home}`- 是无效的（如果它警告你的话） .

恭喜，您的项目现在是不可移植的。在你的文件中内联这个配置文件`pom.xml`可以帮助缓解这个问题，明显的缺点是每个项目层次结构（允许继承的影响）现在必须指定这个信息。由于 Maven 为项目继承提供了良好的支持，因此可以将这种配置粘贴在`<pluginManagement>`团队级 POM 或类似的部分中，并简单地继承路径。

另一个不太吸引人的答案可能是开发环境的标准化。然而，这往往会损害 Maven 能够提供的生产力增益。

#### 自然轮廓集的不完整规范[](https://maven.apache.org/guides/introduction/introduction-to-profiles.html#incomplete-specification-of-a-natural-profile-set)

除了上述可移植性破坏者之外，您的个人资料很容易无法涵盖所有​​情况。当你这样做时，你通常会让你的一个目标环境变得高高干燥。让我们`pom.xml`再看一次上面的示例片段：



现在，考虑以下配置文件，它将在 中内联指定`pom.xml`：



此配置文件看起来与上一个示例中的配置文件非常相似，但有一些重要的例外：它显然是面向开发环境的，`appserverConfig-dev-2`添加了一个名为的新配置文件，并且它有一个激活部分，当系统属性包含“ env=dev" 用于名为的配置文件`appserverConfig-dev`，"env=dev-2" 用于名为`appserverConfig-dev-2`. 所以，执行：



将导致成功构建，应用名为 profile 的属性`appserverConfig-dev-2`。当我们执行



它将导致成功构建应用名为的配置文件给出的属性`appserverConfig-dev`。但是，执行：



不会成功构建。为什么？因为，生成的非插值文字值`${appserver.home}`将不是部署和测试 Web 应用程序的有效路径。在编写配置文件时，我们没有考虑生产环境的情况。“生产”环境（env=production）与“测试”甚至可能是“本地”一起构成了一组自然的目标环境，我们可能希望为其构建集成测试生命周期阶段。这个自然集的不完整规范意味着我们有效地将我们的有效目标环境限制在开发环境中。你的队友——可能还有你的经理——不会看到其中的幽默。当您构建配置文件以处理此类情况时，请务必解决整个目标排列集。

顺便说一句，用户特定的配置文件可能会以类似的方式行事。这意味着当团队添加新的开发人员时，用于处理不同环境的用户配置文件可以发挥作用。虽然我认为这*可以*作为对新手有用的培训，但以这种方式将它们扔给狼群并不好。同样，一定要考虑*整套*配置文件。

### 我如何知道在构建过程中哪些配置文件有效？[](https://maven.apache.org/guides/introduction/introduction-to-profiles.html#how-can-i-tell-which-profiles-are-in-effect-during-a-build)

确定活动配置文件将帮助用户了解在构建期间执行了哪些特定配置文件。我们可以使用[Maven 帮助插件](https://maven.apache.org/plugins/maven-help-plugin/)来了解在构建过程中哪些配置文件有效。



让我们有一些小样本来帮助我们更多地了解该插件的*活动配置文件*目标。

从 中的配置文件的最后一个示例中`pom.xml`，您会注意到有两个配置文件被命名`appserverConfig-dev`并且`appserverConfig-dev-2`被赋予了不同的属性值。如果我们继续执行：



结果将是具有“env = dev”激活属性的配置文件ID的项目符号列表以及声明它的源。请参阅下面的示例。



现在，如果我们在中声明了一个配置文件`settings.xml`（请参阅 中的配置文件示例`settings.xml`）并且已设置为活动配置文件并执行：



结果应该是这样的



尽管我们没有激活属性，但配置文件已被列为活动。为什么？就像我们之前提到的，在 中设置为活动配置文件的配置文件`settings.xml`会自动激活。

现在，如果我们有类似配置文件的东西，`settings.xml`它已被设置为活动配置文件，并且还触发了 POM 中的配置文件。您认为哪个配置文件会对构建产生影响？



这将列出激活的配置文件：



即使它列出了两个活动配置文件，我们也不确定其中哪一个已被应用。要查看对构建的影响，请执行：



这将将此构建配置的有效 POM 打印到控制台。请注意，配置文件中的`settings.xml`配置文件比 POM 中的配置文件具有更高的优先级。所以这里应用的配置文件`appserverConfig`不是`appserverConfig-dev`.

如果要将插件的输出重定向到名为 的文件`effective-pom.xml`，请使用命令行选项`-Doutput=effective-pom.xml`。

### 命名约定[](https://maven.apache.org/guides/introduction/introduction-to-profiles.html#naming-conventions)

到目前为止，您已经注意到配置文件是解决针对不同目标环境的不同构建配置要求问题的一种自然方式。上面，我们讨论了解决这种情况的“自然集”配置文件的概念，以及考虑所需的整个配置文件集的重要性。

然而，如何组织和管理该集合的演变的问题也很重要。正如一个优秀的开发人员努力编写自文档代码一样，您的个人资料 ID 为他们的预期用途提供提示很重要。一种很好的方法是使用公共系统属性触发器作为配置文件名称的一部分。对于由系统属性**env**触发的配置文件，这可能会产生类似**env-dev**、**env-test**和**env-prod**的名称。这样的系统为如何激活针对特定环境的构建留下了非常直观的提示。因此，要激活测试环境的构建，您需要通过发出以下命令来激活**env-test ：**



只需将配置文件 ID 中的“=”替换为“-”即可获得正确的命令行选项。


