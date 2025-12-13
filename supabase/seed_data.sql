-- ============================================
-- BLOGIFY SEED DATA
-- ============================================
-- Safe to re-run: Deletes existing data first

-- ============================================
-- CLEAR EXISTING DATA
-- ============================================

DELETE FROM public.blogs;
DELETE FROM public.profiles;

-- ============================================
-- TEST USERS (Already created in Supabase Auth)
-- ============================================
-- User 1: hmdy7486@gmail.com / Mahmoud21@!
-- User 2: admin@admin.com / admin@admin.com

-- ============================================
-- INSERT PROFILES
-- ============================================

INSERT INTO public.profiles (id, name, email) VALUES
('b32f7dde-a60a-412b-b476-674b659e1966', 'Mahmoud Ahmed', 'hmdy7486@gmail.com'),
('7706012e-a55d-429f-af67-0f1a7dcc08bc', 'Admin User', 'admin@admin.com');

-- ============================================
-- INSERT BLOGS
-- ============================================

INSERT INTO public.blogs (id, poster_id, title, content, image_url, topics, updated_at) VALUES

-- ==================== TECHNOLOGY ====================
(
    'a1111111-1111-1111-1111-111111111111',
    'b32f7dde-a60a-412b-b476-674b659e1966',
    'The Future of Artificial Intelligence in 2025',
    'Artificial Intelligence has transformed from a sci-fi concept to an everyday reality. In 2025, we are witnessing unprecedented advancements in AI technology that are reshaping industries across the globe.

From healthcare to finance, AI is making significant strides. Machine learning algorithms are now capable of diagnosing diseases with accuracy rates surpassing human doctors. Natural Language Processing has evolved to the point where AI can engage in meaningful conversations, write creative content, and even code software.

The rise of generative AI models like GPT and DALL-E has opened new possibilities for content creation. Businesses are leveraging these tools to automate customer service, generate marketing content, and streamline operations.

However, with great power comes great responsibility. The ethical implications of AI are being hotly debated. Questions about job displacement, privacy, and algorithmic bias are at the forefront of policy discussions.

Looking ahead, we can expect AI to become even more integrated into our daily lives. Autonomous vehicles, smart homes, and personalized medicine are just the beginning. The key will be ensuring that AI development remains aligned with human values and benefits society as a whole.

As we navigate this AI-powered future, one thing is certain: adaptability will be the most valuable skill. Embracing AI as a tool for enhancement rather than replacement will be crucial for individuals and organizations alike.',
    'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800&q=80',
    ARRAY['Technology', 'Science', 'Programming'],
    NOW() - INTERVAL '1 hour'
),

-- ==================== PROGRAMMING ====================
(
    'a2222222-2222-2222-2222-222222222222',
    '7706012e-a55d-429f-af67-0f1a7dcc08bc',
    'Flutter vs React Native: Which Should You Choose in 2025?',
    'The battle between Flutter and React Native continues to evolve as both frameworks mature and gain new capabilities. As a mobile developer, choosing the right framework can significantly impact your project success.

Flutter, backed by Google, has gained tremendous popularity with its widget-based approach and hot reload feature. The Dart programming language, while initially unfamiliar to many developers, offers strong typing and excellent performance. Flutter 3.0 brought desktop and web support, making it a truly cross-platform solution.

React Native, maintained by Meta, leverages the vast JavaScript ecosystem. Developers familiar with React can quickly get up to speed. The framework provides native performance through its bridge architecture, and the recent introduction of the New Architecture with Fabric and TurboModules has addressed many performance concerns.

Key Considerations:

**Performance**: Flutter renders directly to the canvas, potentially offering smoother animations. React Native New Architecture significantly improves performance through JSI.

**Developer Experience**: React Native benefits from the JavaScript ecosystem and existing React knowledge. Flutter requires learning Dart but offers excellent tooling.

**UI Consistency**: Flutter provides pixel-perfect UI across platforms. React Native components adapt to platform-specific designs.

**Community & Ecosystem**: Both have strong communities, though React Native has a larger package ecosystem due to JavaScript roots.

My recommendation: Choose Flutter for apps requiring custom UI and animations. Choose React Native if your team has strong JavaScript/React experience and you need quick integration with native modules.',
    'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800&q=80',
    ARRAY['Programming', 'Technology'],
    NOW() - INTERVAL '3 hours'
),

(
    'a3333333-3333-3333-3333-333333333333',
    'b32f7dde-a60a-412b-b476-674b659e1966',
    'Clean Architecture: Building Scalable Applications',
    'Clean Architecture, introduced by Robert C. Martin (Uncle Bob), has become a cornerstone of modern software development. This architectural pattern emphasizes separation of concerns and dependency inversion, making applications more testable, maintainable, and scalable.

The core principle of Clean Architecture is the Dependency Rule: source code dependencies must point only inward, toward higher-level policies. The inner circles represent business logic, while outer circles represent implementation details like UI and databases.

**The Layers**

1. **Entities**: Core business objects that encapsulate enterprise-wide business rules.

2. **Use Cases**: Application-specific business rules. They orchestrate the flow of data to and from entities.

3. **Interface Adapters**: Convert data between use cases and external agencies like databases and web frameworks.

4. **Frameworks & Drivers**: The outermost layer containing frameworks and tools like databases, web frameworks, and UI.

**Benefits in Practice**

- **Testability**: Business logic can be tested without UI, database, or external dependencies.
- **Independence**: The architecture does not depend on any external agency.
- **Flexibility**: You can swap out UI or database without affecting business logic.

**Implementation Tips**

When implementing Clean Architecture in Flutter, structure your features with data, domain, and presentation layers. Use dependency injection to manage dependencies and keep your code loosely coupled.

Remember, Clean Architecture is a guideline, not a strict rulebook. Adapt it to your project needs while maintaining the core principles of separation and dependency inversion.',
    'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=800&q=80',
    ARRAY['Programming', 'Technology'],
    NOW() - INTERVAL '5 hours'
),

-- ==================== BUSINESS ====================
(
    'b1111111-1111-1111-1111-111111111111',
    '7706012e-a55d-429f-af67-0f1a7dcc08bc',
    'Building a Successful Startup: Lessons from the Trenches',
    'After five years of building startups, I have learned that success is rarely about the idea—it is about execution, resilience, and timing. Here are the lessons that transformed my approach to entrepreneurship.

**Start with the Problem, Not the Solution**

Too many founders fall in love with their solution before validating the problem. Spend time talking to potential customers. Understand their pain points deeply. The best products solve real problems that people are actively trying to solve.

**Build Your MVP Faster Than You Think**

Perfectionism is the enemy of progress. Your first version will be embarrassing—and that is okay. Ship early, get feedback, and iterate. The market will tell you what features matter.

**Cash Flow is King**

Revenue solves many problems. Focus on getting paying customers early. Bootstrapping forces discipline and ensures you are building something people actually want to pay for.

**Hire Slow, Fire Fast**

Your early team defines your culture. Take time to find people who align with your vision and values. But when someone is not working out, act quickly. A bad hire can derail a small team.

**Embrace Failure as Learning**

Every failed experiment is data. Document what went wrong and why. The fastest-learning teams are those that fail frequently but never make the same mistake twice.

The startup journey is a marathon, not a sprint. Build sustainable habits, take care of your health, and remember why you started. The world needs more people solving meaningful problems.',
    'https://images.unsplash.com/photo-1553028826-f4804a6dba3b?w=800&q=80',
    ARRAY['Business', 'Technology'],
    NOW() - INTERVAL '8 hours'
),

-- ==================== HEALTH ====================
(
    'c1111111-1111-1111-1111-111111111111',
    'b32f7dde-a60a-412b-b476-674b659e1966',
    'The Science of Sleep: Optimizing Your Rest for Peak Performance',
    'Sleep is the foundation of human performance, yet it is often the first thing we sacrifice in our busy lives. Understanding the science behind sleep can help you optimize your rest and transform your waking hours.

**The Sleep Cycles**

Sleep occurs in 90-minute cycles, alternating between REM (Rapid Eye Movement) and non-REM stages. Non-REM sleep is crucial for physical restoration, while REM sleep consolidates memories and processes emotions.

**The Circadian Rhythm**

Your body has an internal clock regulated by light exposure. Morning sunlight helps set this clock, promoting alertness during the day and sleepiness at night. Artificial light, especially blue light from screens, can disrupt this rhythm.

**Practical Sleep Optimization**

1. **Consistent Schedule**: Go to bed and wake up at the same time daily, even on weekends.

2. **Temperature Control**: Your body needs to cool down for sleep. Keep your bedroom between 65-68°F (18-20°C).

3. **Light Management**: Dim lights 1-2 hours before bed. Use blue light filters on devices.

4. **Caffeine Timing**: Avoid caffeine after 2 PM. Its half-life is 5-6 hours.

5. **Wind-Down Routine**: Create a relaxing pre-sleep ritual. Reading, stretching, or meditation can signal your body it is time to rest.

**The Power Nap Protocol**

If you need a daytime boost, keep naps under 20 minutes to avoid sleep inertia. The ideal nap window is between 1-3 PM when your circadian rhythm naturally dips.

Investing in sleep is investing in every aspect of your life. Your creativity, decision-making, and emotional resilience all depend on quality rest.',
    'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?w=800&q=80',
    ARRAY['Health', 'Science'],
    NOW() - INTERVAL '12 hours'
),

-- ==================== TRAVEL ====================
(
    'd1111111-1111-1111-1111-111111111111',
    '7706012e-a55d-429f-af67-0f1a7dcc08bc',
    'Hidden Gems of Southeast Asia: Beyond the Tourist Trail',
    'Southeast Asia offers more than just the well-trodden paths of Bangkok temples and Bali beaches. Venture off the beaten track to discover authentic experiences that will stay with you forever.

**Kampot, Cambodia**

This sleepy riverside town feels like stepping back in time. French colonial architecture lines quiet streets, and the surrounding countryside produces the world best pepper. Take a sunset boat ride on the Praek Tuek Chhu River and visit the abandoned Bokor Hill Station for stunning views.

**Phong Nha, Vietnam**

Home to the world largest cave, Son Doong, this region offers incredible underground adventures. Even if you cannot secure a spot on the exclusive Son Doong expedition, Paradise Cave and the Dark Cave provide unforgettable experiences.

**Flores, Indonesia**

Skip Bali and head to Flores for the real Indonesia. The Kelimutu tri-colored lakes are otherworldly, and the traditional villages of the Ngada people offer glimpses into ancient cultures. Do not miss the Komodo National Park for dragon encounters.

**Hsipaw, Myanmar**

This small town in Shan State is perfect for trekking through hill tribe villages. The train journey from Mandalay crosses the Gokteik Viaduct, one of the world highest railway bridges—a thrilling engineering marvel.

**Travel Tips**

- Learn basic local phrases; it opens doors and hearts.
- Travel slow; one week in a place beats three days in three places.
- Eat where locals eat; the best food is rarely in tourist restaurants.
- Support local businesses and be mindful of your environmental impact.

The real magic of travel lies in unexpected connections and unplanned detours. Leave room for serendipity.',
    'https://images.unsplash.com/photo-1528181304800-259b08848526?w=800&q=80',
    ARRAY['Travel', 'World'],
    NOW() - INTERVAL '1 day'
),

-- ==================== GAMING ====================
(
    'e1111111-1111-1111-1111-111111111111',
    'b32f7dde-a60a-412b-b476-674b659e1966',
    'The Rise of Indie Games: How Small Studios Are Changing Gaming',
    'The gaming industry has witnessed a remarkable shift. While AAA titles continue to dominate headlines with massive budgets, indie games are capturing hearts and reshaping what we expect from interactive entertainment.

**The Indie Revolution**

Games like Hollow Knight, Celeste, and Hades have proven that small teams can create experiences rivaling big-budget productions. These games succeed not despite their limitations but because of them—constraints breed creativity.

**What Makes Indie Games Special**

1. **Artistic Vision**: Without corporate oversight, indie developers can take creative risks. The result is games that feel personal and unique.

2. **Innovation**: Indies pioneer new genres and mechanics. Roguelikes, walking simulators, and narrative adventures all found their footing in the indie space.

3. **Accessibility**: Lower price points and often lower system requirements make indie games accessible to broader audiences.

4. **Community Connection**: Indie developers often engage directly with their communities, incorporating feedback and building loyal fanbases.

**Notable Releases to Watch**

The indie scene continues to thrive with titles pushing boundaries in narrative, art style, and gameplay mechanics. Platforms like Steam, itch.io, and the Nintendo eShop have become treasure troves of innovative experiences.

**Supporting Indie Development**

- Wishlist games you are interested in; it helps with visibility
- Leave reviews; they matter more than you think
- Share discoveries with friends; word of mouth is powerful
- Consider early access with patience; you are supporting development

The future of gaming is being written by passionate developers in bedrooms and small studios around the world. Keep exploring, and you will find experiences that mainstream gaming rarely offers.',
    'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=800&q=80',
    ARRAY['Gaming', 'Entertainment', 'Technology'],
    NOW() - INTERVAL '1 day 6 hours'
),

-- ==================== FOOD ====================
(
    'f1111111-1111-1111-1111-111111111111',
    '7706012e-a55d-429f-af67-0f1a7dcc08bc',
    'The Art of Fermentation: Ancient Techniques for Modern Kitchens',
    'Fermentation is experiencing a renaissance. This ancient preservation technique not only extends shelf life but creates complex flavors and boosts nutritional value. Let us explore how you can bring fermentation into your kitchen.

**Understanding Fermentation**

At its core, fermentation is controlled decomposition. Beneficial bacteria, yeasts, or molds transform sugars into acids, gases, or alcohol. The result? Everything from tangy sauerkraut to bubbly kombucha.

**Getting Started: Sauerkraut**

The perfect beginner project. You need only cabbage and salt.

1. Shred one head of cabbage finely
2. Add 2 tablespoons of salt
3. Massage until liquid releases (10-15 minutes)
4. Pack tightly into a jar, submerging cabbage in its brine
5. Cover loosely and ferment at room temperature for 1-4 weeks

**Kombucha Basics**

This fermented tea requires a SCOBY (Symbiotic Culture of Bacteria and Yeast).

1. Brew strong sweet tea (1 cup sugar per gallon)
2. Cool completely
3. Add SCOBY and starter liquid
4. Cover with cloth and ferment 7-14 days
5. Bottle with fruit for secondary fermentation

**Safety Tips**

- Use clean equipment but do not sterilize—you want good bacteria
- Trust your senses: if it smells off, it probably is
- Keep ferments at consistent temperatures
- Salt inhibits harmful bacteria; do not reduce salt in recipes

**The Health Benefits**

Fermented foods are probiotic powerhouses. They support gut health, boost immunity, and may improve mental health through the gut-brain connection.

Start small, experiment often, and soon you will have a fermenting station that rivals any artisan producer. The flavors you create will be uniquely yours.',
    'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=800&q=80',
    ARRAY['Food', 'Health'],
    NOW() - INTERVAL '2 days'
),

-- ==================== NATURE ====================
(
    '01111111-1111-1111-1111-111111111111',
    'b32f7dde-a60a-412b-b476-674b659e1966',
    'The Secret Life of Trees: Understanding Forest Communication',
    'Forests are not collections of individual trees but interconnected communities with sophisticated communication networks. Recent scientific discoveries are revolutionizing our understanding of plant intelligence.

**The Wood Wide Web**

Beneath the forest floor lies a vast network of fungal threads called mycelium. Trees use this network to share resources and information. A mother tree can recognize her offspring and preferentially send them nutrients through these fungal connections.

**Chemical Conversations**

When attacked by insects, trees release volatile organic compounds that warn neighboring trees. These neighbors then produce defensive chemicals before the threat arrives. It is an early warning system spanning acres.

**Resource Sharing**

Trees do not just compete; they cooperate. Healthy trees share sugars with struggling neighbors, including trees of different species. This cooperation benefits the entire forest ecosystem, creating resilience against environmental stresses.

**The Intelligence Debate**

While trees lack brains, they exhibit behaviors we might call intelligent:
- They remember past droughts and adjust water usage
- They count cold days to time spring budding
- They solve problems of resource allocation

**Conservation Implications**

Understanding forest communication changes how we should manage forests:
- Preserving old-growth trees (hub trees) maintains network integrity
- Clear-cutting destroys communication infrastructure
- Diverse forests are more resilient than monocultures

**What You Can Do**

- Support old-growth forest preservation
- Plant native trees that can integrate into local networks
- Reduce forest fragmentation by connecting green spaces

The next time you walk through a forest, remember: you are walking through a living, communicating community millions of years in the making.',
    'https://images.unsplash.com/photo-1448375240586-882707db888b?w=800&q=80',
    ARRAY['Nature', 'Science'],
    NOW() - INTERVAL '2 days 12 hours'
),

-- ==================== MUSIC ====================
(
    '02111111-1111-1111-1111-111111111111',
    '7706012e-a55d-429f-af67-0f1a7dcc08bc',
    'The Psychology of Music: Why Certain Songs Move Us',
    'Music has the power to bring us to tears, fill us with joy, or transport us to distant memories. But what is it about certain combinations of sounds that affects us so deeply? Let us explore the science behind music emotional impact.

**The Brain on Music**

When we listen to music, our entire brain lights up. The auditory cortex processes sound, the motor cortex makes us want to move, and the limbic system—our emotional center—releases dopamine. Music is unique in its ability to engage so many brain regions simultaneously.

**Why We Get Chills**

Musical chills, or frisson, occur when music creates tension and release. An unexpected chord change, a soaring melody, or a powerful crescendo can trigger this response. Studies show that people who experience frisson often have more neural connections between auditory and emotional processing areas.

**The Power of Familiarity**

We tend to prefer music we have heard before—the mere exposure effect. But there is a sweet spot: we enjoy music that is familiar enough to be comfortable yet novel enough to be interesting. This balance explains why great songs often subvert expectations while staying within recognizable frameworks.

**Music and Memory**

Music is deeply tied to autobiographical memory. A song from your teenage years can instantly transport you back in time because music and memories are encoded together. This is why music therapy shows promise for dementia patients.

**Creating Emotional Playlists**

Understanding music psychology can help you curate better playlists:
- For focus: instrumental music at 60-80 BPM
- For energy: upbeat music at 120-140 BPM
- For relaxation: slow, consonant music with predictable patterns
- For emotional processing: music that mirrors your current state before transitioning

Music is not just entertainment—it is a powerful tool for emotional regulation, memory, and connection. Use it wisely.',
    'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=800&q=80',
    ARRAY['Music', 'Science', 'Entertainment'],
    NOW() - INTERVAL '3 days'
),

-- ==================== FASHION ====================
(
    '03111111-1111-1111-1111-111111111111',
    'b32f7dde-a60a-412b-b476-674b659e1966',
    'Sustainable Fashion: Building a Conscious Wardrobe',
    'The fashion industry is one of the world largest polluters. But as consumers, we have the power to drive change. Here is how to build a wardrobe that is both stylish and sustainable.

**The Problem with Fast Fashion**

The average person buys 60% more clothing than 15 years ago but keeps each garment half as long. Fast fashion encourages disposable consumption, with massive environmental and human costs.

**Building a Capsule Wardrobe**

Quality over quantity is the foundation of sustainable fashion:

1. **Assess what you have**: Before buying anything new, inventory your closet
2. **Define your style**: Choose a cohesive color palette and aesthetic
3. **Invest in basics**: Well-made foundational pieces last years
4. **The 30-wear test**: Before purchasing, ask "Will I wear this 30 times?"

**Sustainable Shopping Strategies**

- **Secondhand first**: Thrift stores, consignment shops, and online resale platforms offer unique finds
- **Research brands**: Look for certifications like B Corp, Fair Trade, or GOTS
- **Choose natural fibers**: Organic cotton, linen, hemp, and responsibly sourced wool
- **Support local**: Local artisans often use sustainable practices

**Caring for Your Clothes**

Extending garment life is the most sustainable choice:
- Wash less frequently and in cold water
- Air dry when possible
- Learn basic repairs: buttons, hems, small tears
- Store properly to prevent damage

**The Future of Fashion**

Innovations like mushroom leather, recycled ocean plastic, and rental/subscription models are reshaping the industry. Support brands leading this change.

True style is not about having more—it is about curating pieces that represent who you are and wearing them with intention.',
    'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&q=80',
    ARRAY['Fashion', 'World'],
    NOW() - INTERVAL '3 days 6 hours'
),

-- ==================== BOOKS ====================
(
    '04111111-1111-1111-1111-111111111111',
    '7706012e-a55d-429f-af67-0f1a7dcc08bc',
    'Reading in the Digital Age: Finding Balance in a World of Screens',
    'In an era of endless scrolling and instant entertainment, the art of deep reading faces new challenges. But books offer something screens cannot: the opportunity for focused, transformative thinking.

**The Deep Reading Brain**

When we read long-form content, we develop neural pathways for concentration, empathy, and critical thinking. Skimming social media uses different circuits. Without regular practice, our capacity for deep reading atrophies.

**Reclaiming Your Reading Life**

1. **Create a reading ritual**: Same time, same place builds habit
2. **Start small**: 20 pages daily is better than ambitious goals abandoned
3. **Eliminate distractions**: Phone in another room, notifications off
4. **Mix formats**: E-readers for convenience, physical books for retention

**Building a Reading Practice**

- **Morning reading**: Start your day with books, not news
- **Lunch reading**: 15 minutes of fiction provides mental reset
- **Evening reading**: Better for sleep than screens
- **Commute audio**: Audiobooks make travel productive

**Choosing What to Read**

Life is too short for books you do not enjoy. Give a book 50-100 pages, then move on if it does not resonate. Read what excites you, not what you think you should read.

**The Social Aspect**

Join a book club or online reading community. Discussing books deepens understanding and introduces you to perspectives you might otherwise miss.

**My Current Recommendations**

Keep a list of books you have enjoyed and why. Review it when you need inspiration. And remember: rereading favorites is not a waste—it is how we internalize wisdom.

In a distracted world, the ability to focus on a book for hours is a superpower. Cultivate it.',
    'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=800&q=80',
    ARRAY['Books', 'Entertainment'],
    NOW() - INTERVAL '4 days'
),

-- ==================== SPORTS ====================
(
    '05111111-1111-1111-1111-111111111111',
    'b32f7dde-a60a-412b-b476-674b659e1966',
    'The Mental Game: Sports Psychology for Everyday Athletes',
    'Elite athletes understand that physical training is only half the equation. The mental game often determines who stands on the podium. But these psychological techniques are not just for professionals—they can transform your fitness journey.

**Visualization: The Mental Rehearsal**

Olympic athletes spend hours visualizing perfect performances. Research shows that mental practice activates the same neural pathways as physical practice. Before your next workout or competition:

1. Find a quiet space and close your eyes
2. Vividly imagine yourself performing perfectly
3. Engage all senses: feel the movements, hear the sounds
4. Practice handling challenges mentally before they occur

**Goal Setting: The SMART Framework**

Effective goals are Specific, Measurable, Achievable, Relevant, and Time-bound. But elite athletes add two more elements:

- **Process goals**: Focus on execution, not outcomes
- **Stepping stones**: Break big goals into weekly milestones

**Managing Performance Anxiety**

Pre-competition nerves are normal—even beneficial. Reframe anxiety as excitement. Both states involve similar physiological responses; it is your interpretation that matters.

Techniques for calming nerves:
- Deep breathing: 4 counts in, 7 hold, 8 out
- Progressive muscle relaxation
- Positive self-talk scripts
- Focus on controllables only

**Building Mental Toughness**

Mental toughness is not about suppressing emotions—it is about performing despite them. Build it through:

- Intentionally challenging yourself in training
- Reflecting on past obstacles overcome
- Developing pre-performance routines
- Practicing mindfulness regularly

**The Recovery Mindset**

Rest is training. Elite athletes take recovery as seriously as workouts. This includes mental recovery: time away from thinking about sport is essential for long-term performance.

Your mind is your most powerful training tool. Develop it with the same dedication you give your body.',
    'https://images.unsplash.com/photo-1461896836934- voices?w=800&q=80',
    ARRAY['Sports', 'Health'],
    NOW() - INTERVAL '4 days 12 hours'
);

-- ============================================
-- VERIFY DATA
-- ============================================

SELECT 'Profiles count: ' || COUNT(*) FROM public.profiles;
SELECT 'Blogs count: ' || COUNT(*) FROM public.blogs;
SELECT title, array_length(topics, 1) as topic_count FROM public.blogs ORDER BY updated_at DESC;
